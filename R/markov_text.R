desc <- n <- num <- pct <- text <- word <- word2 <- word3 <- NULL

#' Generate word-frequency table for Markov text generation.
#'
#' @param text_input A `tbl_df` with a column named `text`.
#' @param num_words (Default 500) The number of unique words to include in the table.
#' @param n_grams (Default 2) Accepts values 2 or 3. How many words should we look at when computing frequencies?
#'
#' @return A `tbl_df` suitable for markov_text::generate_text().
#' @export
#'
#' @examples
#' \dontrun{wordfreqs_prideprejudice <- get_word_freqs(dplyr::tibble(text = janeaustenr::prideprejudice))
#' generate_text(wordfreqs_prideprejudice)
#' }
get_word_freqs <- function(text_input, num_words = 500, n_grams = c(2,3)){

  # input validation
  if (!(is.character(text_input) | ("data.frame" %in% class(text_input))) |
      (("data.frame" %in% class(text_input)) & (!"text" %in% colnames(text_input)))) stop ("text_input must be either a character vector or a data.frame with a column named 'text'.")

  if (is.character(text_input)) text_input <- dplyr::tibble(text = text_input)

  # add a period so that the first sentence is treated equally to the others.
  text_input <- dplyr::mutate(text_input, text = paste0(". ", text))

  n_grams <- as.character(n_grams)
  n_grams <- match.arg(n_grams, n_grams)
  n_grams <- as.numeric(n_grams)
  if (!is.numeric(n_grams) | is.na(n_grams)) stop ("n_grams must be either 2 or 3.")

  num_words <- as.numeric(num_words)
  if(!is.numeric(num_words) | is.na(num_words)) stop ("num_words must be numeric.")



  punctuation_marks <- c("xperiodx", "xcommax", "xquestionx", "xexclamationx" )

  text_words <- text_input %>%
    dplyr::mutate(text = stringr::str_replace_all(text, "\\.", " xperiodx"),
           text = stringr::str_replace_all(text, "\\,", " xcommax"),
           text = stringr::str_replace_all(text, "\\?", " xquestionx"),
           text = stringr::str_replace_all(text, "\\!", " xexclamationx")) %>%
    dplyr::transmute(word = (stringr::str_split(tolower(text), "\\s+"))) %>%
    tidyr::unnest(word) %>%
    dplyr::mutate(word = stringr::str_remove_all(word, "[:punct:]+$|^[:punct:]+")) %>%
    dplyr::filter(!stringr::str_detect(word, "[0-9]")) %>%
    dplyr::filter(word != "")

  word_counts <- text_words %>%
    dplyr::group_by(word) %>%
    dplyr::count(name = "num") %>%
    dplyr::ungroup() %>%
    dplyr::arrange(dplyr::desc(num)) %>%
    dplyr::slice_head(n=num_words)

  if (n_grams == 2){
    word_freqs <- text_words %>%
      dplyr::filter(word %in% word_counts$word) %>%
      dplyr::mutate(word2 = dplyr::lead(word)) %>%
      dplyr::group_by(word, word2) %>%
      dplyr::count() %>%
      dplyr::filter(word != word2) %>%
      dplyr::filter(!(word %in% punctuation_marks & word2 %in% punctuation_marks)) %>%
      dplyr::group_by(word) %>%
      dplyr::mutate(pct = cumsum(n/sum(n)))
  }

  if (n_grams == 3){
    word_freqs <- text_words %>%
      dplyr::filter(word %in% word_counts$word) %>%
      dplyr:: mutate(word2 = dplyr::lead(word),
             word3 = dplyr::lead(word, n = 2)) %>%
      dplyr::group_by(word, word2, word3) %>%
      dplyr::count() %>%
      dplyr::filter(word != word2,
             word2 != word3,
             word != word3) %>%
      dplyr:: filter(!(word %in% punctuation_marks & word2 %in% punctuation_marks),
             !(word2 %in% punctuation_marks & word3 %in% punctuation_marks)) %>%
      dplyr::group_by(word, word2) %>%
      dplyr::mutate(pct = cumsum(n/sum(n)))
  }

  word_freqs <- dplyr::ungroup(word_freqs)

  return(word_freqs)
}



#' Generate random text using Markov chains.
#'
#' @param word_freqs A `tbl_df` output from `markov_text::get_word_freqs()`.
#' @param word_length (Default 200) The length in words of the text to generate.
#' @param start_word (Optional) A starting word.
#' @param rnd_seed (Optional) A random number seed. Useful for reproducing results.
#'
#' @return A character vector containing randomly generated text.
#' @export
#'
#' @examples
#' \dontrun{wordfreqs_prideprejudice <- get_word_freqs(dplyr::tibble(text = janeaustenr::prideprejudice))
#' generate_text(wordfreqs_prideprejudice)
#' }
generate_text <- function(word_freqs, word_length = 200, start_word = NA, rnd_seed = NA){

  punctuation_marks <- c("xperiodx", "xquestionx", "xeclamationx", "xcommax")
  punctuation_marks_caps <- c("xperiodx", "xquestionx", "xexclamationx" )

  if (is.na(rnd_seed)) rnd_seed <- round(stats::runif(n=1)*1000)

  # choose our starting word, either given by user or a period.
  start_word <- tolower(start_word)
  if (is.na(start_word)) start_word <- "xperiodx"

  generated_text <- NULL
  set.seed(rnd_seed)

  # doing 2-grams
  if (!"word3" %in% colnames(word_freqs)){
    last_word <- start_word


    for (i in 1:word_length){
      #message(i)
      random_num <- stats::runif(n=1, min=0, max=1)

      # pick next word using probabilities based on last word
      next_word <- word_freqs %>%
        dplyr::filter(word == tolower(last_word),
               pct > random_num) %>%
        dplyr::slice_head(n=1) %>%
        dplyr::pull(word2)

      # if we are at a dead end, pick a random word
      if (length(next_word) == 0) {
        rnd_num <- stats::runif(n=1, min=1, max = nrow(word_freqs))
        next_word <- word_freqs$word[[rnd_num]]
      }

      # capitalize if we need to
      if (last_word %in% punctuation_marks_caps) {
        next_word <- paste0(toupper(substring(next_word, 1, 1)),
                            tolower(substring(next_word, 2, nchar(next_word))))
      }

      generated_text <- paste(generated_text, next_word)

      last_word <- next_word

    }
  }

  if ("word3" %in% colnames(word_freqs)){

    # try to start with text that begins a sentence, if possible
    last_word1 <- "xperiodx"
    if (start_word == "xperiodx"){
      last_word2 <- word_freqs %>%
        dplyr::ungroup() %>%
        dplyr::filter(word == last_word1) %>%
        dplyr::slice_sample(n=1) %>%
        dplyr::pull(word2)
    } else {
      last_word2 <- start_word
    }

    # if the input text doesn't have regular punctuation (maybe it's too short)
    # ensure we start with some valid ngram if the above didn't work
    if (length(last_word2) == 0){
      rnd_num <- round(stats::runif(n=1, min = 1, max = nrow(word_freqs)))
      last_word1 <- word_freqs$word[[rnd_num]]
      last_word2 <- word_freqs$word2[[rnd_num]]
    }

    # capitalize our first word
    last_word2 <- paste0(toupper(substring(last_word2, 1, 1)),
                         tolower(substring(last_word2, 2, nchar(last_word2))))

    # start with our first word, as long as it's not a randomly-selected
    # punctuation mark
    if (!tolower(last_word2) %in% punctuation_marks){
    generated_text <- last_word2
    } else {
      generated_text <- NULL
    }


    for (i in 1:word_length){

      #message(i)
      random_num <- stats::runif(n=1, min=0, max=1)

      next_word <- word_freqs %>%
        dplyr::filter(word == tolower(last_word1),
               word2 == tolower(last_word2)) %>%
        dplyr::filter(pct > random_num) %>%
        dplyr::slice_head(n=1) %>%
        dplyr::pull(word3)

      if (length(next_word) == 0){
        next_word <- word_freqs %>%
          dplyr::filter(word2 == tolower(last_word2)) %>%
          dplyr::slice_sample(n=1) %>%
          dplyr::pull(word3)
      }

      if (length(next_word) == 0){
        next_word <- sample(word_freqs$word[!word_freqs$word %in% punctuation_marks], size = 1)
      }


      if (last_word2 %in% punctuation_marks_caps){
        next_word <-   paste0(toupper(substring(next_word, 1, 1)),
                              tolower(substring(next_word, 2, nchar(next_word))))
      }

      generated_text <- paste(generated_text, next_word)

      last_word1 <- last_word2
      last_word2 <- next_word

    }
  }

  generated_text <- generated_text %>%
    stringr::str_replace_all(" xperiodx", "\\.") %>%
    stringr::str_replace_all(" xcommax", "\\,") %>%
    stringr::str_replace_all(" xquestionx", "\\?") %>%
    stringr::str_replace_all(" xexclamationx", "\\!") %>%
    stringr::str_replace_all(" i ", " I ") %>%
    stringr::str_squish()

  generated_text
}

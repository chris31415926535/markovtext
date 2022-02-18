whale_text <- "Ahhh! Woooh! What’s happening? Who am I? Why am I here? What’s my purpose in life? What do I mean by who am I? Okay okay, calm down calm down get a grip now. Ooh, this is an interesting sensation. What is it? Its a sort of tingling in my… well I suppose I better start finding names for things. Lets call it a… tail! Yeah! Tail! And hey, what’s this roaring sound, whooshing past what I’m suddenly gonna call my head? Wind! Is that a good name? It’ll do. Yeah, this is really exciting. I’m dizzy with anticipation! Or is it the wind? There’s an awful lot of that now isn’t it? And what’s this thing coming toward me very fast? So big and flat and round, it needs a big wide sounding name like ‘Ow’, 'Ownge’, 'Round’, 'Ground’! That’s it! Ground! Ha! I wonder if it’ll be friends with me? Hello Ground!"

wordfreqs_whale_3grams <- markovtext::get_word_freqs(whale_text,
                                                     n_grams = 3)

usethis::use_data(wordfreqs_whale_3grams, overwrite = TRUE)

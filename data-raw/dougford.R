## code to prepare `dougford` dataset goes here
# https://www.macleans.ca/politics/doug-fords-victory-speech-ontario-is-open-for-business-full-transcript/
doug_ford_victory <- dplyr::tibble(text = "Wow! I’ll tell ya.

That’s an incredible welcome, I thank you. Hazel McCallion, I thank you.

Thank you so much my friends what a response. This is incredible. Thank you from the bottom of my heart. I’ll never forget the trust you put in me. My friends this victory belongs to you. this victory belongs to the people. And tonight the people of Ontario have spoken.

People from every walk of life, from every corner of this great province, people from every political stripe, you have come together around one common vision of Ontario. You have sent a clear message: a message of hope and prosperity.

A vision for the people of this province, a vision of a government that works for the people. A government that respects you, a government with integrity, a government that will always put you first.

My friends, help is here.

Our team will work every single day to deliver this vision. We will every single day for a better Ontario, a better future and a brighter future for our children. An era of economic prosperity, the likes of which this province has never seen before. Prosperity that will benefit every resident of Ontario, and tonight we have sent a clear message to the world: Ontario is open for business.

My friends, I am so proud. So proud of the incredible team that you have sent to Queen’s Park: a team of all-stars that will work for you, a team that will always put you first and we are grateful to all of those who put their names forward. All of those who ran under the PC banner, thank you for your hard work and sacrifice.

My friends, when we began this journey, I made a commitment to you. I made a commitment to Ontario. I promised to work hard, I promised to run an honest and positive campaign, to focus on the policies that matter to you. I promised to deliver a strong, stable majority government and together we did that.

Together we made history. We have taken back Ontario. We have delivered a government that is for the people. A government that will respect your hard-earned tax dollars. And my friends, the party with the tax payers dollars is over, it’s done. But the work has just begun. Our team will get to work immediately. We will deliver on our plan for the people. We will bring accountability, transparency and integrity to the tax payers of Ontario. We will reduce your taxes, reduce your gas prices and keep more money in your pocket.

A plan to fix our economy and create more good, paying jobs. A plan to invest in the priorities that matter to you. And, my friends, together, with our skilled team of MVPs, this is what we will deliver.

My friends, I want to thank my family for all of your support, love and support. To my wife, Karla, my mom, Diane, and my four girls, you’ve been my rock. I couldn’t have done this without you. And I can tell you, I know that my brother Rob is looking down from heaven.

I’m just getting chills talking about him right now. I know Rob is celebrating with us tonight, we owe so much to Rob’s legacy. A legacy of service to the people, a legacy started by my father, Doug Ford Sr., and legacy that will continue.

I want to thank my incredible campaign team, the best political team ever assembled, ever. A skilled and dedicated team who worked hard and stuck together. And I want to thank the thousands and thousands of volunteers from all across Ontario. You left everything on the field.

But most of all, I want to thank each of you, I thank you. I want to thank the people of Ontario, I owe everything to you. Your support, your energy, your belief in our cause. You are the ones who kept me going, who energized me at every single stop and reminded me what’s at stake, what we are fighting for. You reminded me to stay humbled and stay focused. You are the reason we are here today.

Those who didn’t support us, I want you to know I will work even harder to earn your confidence. I also need to acknowledge my opponents in this race. To Kathleen Wynne and Andrea Horwath, you fought a hard, very hard campaign. And I’ll tell you, Ontario is better for it. We have had our different approaches but we all share in the same goal of a better Ontario.

And I want to work together to deliver on our mandate, a mandate for the people.

My friends, a new day has dawned on Ontario! A day of opportunity, a day of prosperity and a day of growth. We’re going to turn this province around, so our children and their children will always be proud to call Ontario home.

We will make sure Ontario is the greatest place on Earth to live, to do business and to raise a family. And we will make Ontario once again the engine of Canada.

My friends, together in 88 short days we achieved the impossible. We united our party, and united our province and this is your victory. Tonight is your night.

I thank you, and God bless each and every one of you. Thank you.")

wordfreqs_dougford_2grams <- markovtext::get_word_freqs(text_input = doug_ford_victory,
                                                        n_grams = 2)
wordfreqs_dougford_3grams <- markovtext::get_word_freqs(text_input = doug_ford_victory,
                                                           n_grams = 3)

usethis::use_data(wordfreqs_dougford_2grams, overwrite = TRUE)
usethis::use_data(wordfreqs_dougford_3grams, overwrite = TRUE)

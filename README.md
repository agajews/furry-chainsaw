# Furry Chainsaw
## Depression Detection -- Connecting People in Times of Need

When we are depressed or feeling sad, talking to a friend is often the best way to find our center. However,
	1) People often underestimate just how bad they're feeling
	2) It's really hard to actively reach out for help, *especially* when we are depressed and need it the most

We decided to fix both of these problems by leveraged background data, specifically heart rate and social media posts, to detect when someone is feeling down, and automatically notify a friend so they can check in and make sure everything is okay.



---

# How it works

Our app currently uses the following data:
* Heart Rate Variability (HRV) from Apple Watch
* Sentiment Analysis on Social Media Posts (Facebook, Twitter)


Heart Rate Variability (HRV) is the variation in time interval between heartbeats. [Studies](https://www.ncbi.nlm.nih.gov/pubmed/11138999) have shown that decreased HRV correlates with a higher chance of depression or states of high emotional stress. This is especially telling if someone's HRV suddenly drops over an extended period of time compared to their previous baseline.

We augment this analysis with sentiment analysis on social media posts. For those who posts multiple times a day on Facebook, a sudden change in the words of their posts can be indicative of a change in mood, and if their mood worsens, maybe they could use some help.


---

# Features

Our users can opt-in to be self-notified and/or send texts to their most trusted friends when we detect depressed symptoms over many days. They can also view their historic mood graphs within the app and on a web server.



---

# Contributing

Like what you see? Check out our [contributing guide](https://github.com/CoinTK/BitBox-Server/blob/master/CONTRIBUTING.md) to see how you can help!

# License

CoinTK is [MIT licensed](http://mit-license.org/).

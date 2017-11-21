# The Bridge
## Depression Detection -- Bringing People Together in Times of Need

When we are depressed or feeling sad, talking to a friend is often the best way to find our center. However,
	
1. People often underestimate just how bad they're feeling
2. It's really hard to actively reach out for help, **especially** when we are depressed and need it the most

We decided to fix both of these problems by leveraged background data, specifically heart rate and social media posts, to detect when someone is feeling down, and automatically notify a friend so they can check in and make sure everything is okay.

Life can be hard, but you don't have to go through it alone.


# Implementation Details

Our app currently uses the following data to predict depression:
* Heart Rate Variability (HRV) from Apple Watch
* Sentiment Analysis on Social Media Posts (Facebook, Twitter)
* Body Temperature (WIP)
* Facial detection and mood analysis on selfies, Facebook pictures, and other social media image posts (WIP)
* Background facial recognition through camera (WIP)
* Facebook comments and Like/React behaviors (WIP)


Heart Rate Variability (HRV) is the variation in time interval between heartbeats. [Studies](https://www.ncbi.nlm.nih.gov/pubmed/11138999) have shown that decreased HRV correlates with a higher chance of depression or states of high emotional stress. This is especially telling if someone's HRV suddenly drops over an extended period of time compared to their previous baseline.

[A similar correlation](https://books.google.com/books?id=zgqdBAAAQBAJ&pg=PT540&lpg=PT540&dq=body+temperature+predict+depression&source=bl&ots=Rj5icawZ1u&sig=U6oKmXskQ0d-ShDdS7yFdrbRzv0&hl=en&sa=X&ved=0ahUKEwi6r4yd68TXAhUprFQKHfy0BsEQ6AEILTAA#v=onepage&q=body%20temperature%20predict%20depression&f=false) has been found for other background health data, such as core body temperature (especially during sleep).

We augment this analysis with sentiment analysis on social media posts. For those who posts multiple times a day on Facebook, a sudden change in the words of their posts, or a sudden rise of liking sad photos, can be indicative of a change in mood, and if their mood worsens, maybe they could use some help.

Lastly, facial expression is a great predictor of mood, and by aggregating all the above data points and tracking how someone is feeling over time, we have a well-rounded predictor for depression.


We calculate someone's baseline statistic by taking an average of their past behaviors. To predict mood, we perform an aggregated comparsion of the last few days with the baseline, and if we detect continuous depression, our algorithm will notify friends for help.


---

# Features

Our users can opt-in to be self-notified and/or send texts to their most trusted friends when our algorithm predicts they're in a state of depression.

Every user also have a personal dashboard, where they can view their historic mood graphs (on phone or in browser).

In the future, we will expand our algorithm to predict other mental health issues that are heavily correlated with background health data and social media behavior, such as Bipolar Disorder and ADHD.


---

# Contributing

Like what you see? Check out our [contributing guide](https://github.com/CoinTK/BitBox-Server/blob/master/CONTRIBUTING.md) to see how you can help!

# License

The Bridge is [MIT licensed](http://mit-license.org/).

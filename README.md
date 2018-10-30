# WNS-Analytics-Hackathon-Employee-promotion-predictions
## Introduction to the challenge
<P>   In this competition our client is WNS Analytics, a large MNC company. They want us to identify the right person for a promotion. Currently, this process consists of several steps:</p>

<p> 1. They first identify a set of employees based on recommendations and past performance.</p>
<p> 2. Selected employees go through the separate training and evaluation program for each vertical. These programs are based on the required skill of each vertical.</p>
<p>3 .At the end of the program, based on various factors such as training performance, KPI completion (only employees with KPIs completed greater than 60% are considered) etc., an employee gets a promotion.</p>

## The pipeline of promotions
![github-small](https://cdn-images-1.medium.com/max/1200/1*ccKOnSmXmV4r7u3J5mruig.jpeg)

<p> The whole process takes a lot of time. One way to speed it up, so a company would save time and money, is to determine the right candidate at the checkpoint. We will use a data-driven approach to predict if the candidate would be promoted or not. Our prediction will be based on employee’s performance from nomination for promotion to the checkpoint and number of demographic features.</p>

## Variables Dictionary
![github-small](https://cdn-images-1.medium.com/max/800/1*cxduYBeoeHtImys93IoEHA.png)

<p>I filled missing values in education with Bachelor's and previous_year_rating with a 5. All other features have no missing values and outliers, this dataset was comfortable to work with.

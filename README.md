# Applicant Behaviour Analysis for Internee.pk (Task 8)

## Objective

The goal of this project was to understand how applicants move through the application process on Internee.pk, and to find the steps where they leave. I used SQL to analyse the data and Power BI to show the results in a dashboard.

## Important note about the data

I did not have access to the real Internee.pk Google Analytics account or any real user data. For this reason, the dataset used here is simulated. I created it myself to practise the analysis method. The numbers in this project show how the analysis works. They should not be taken as real Internee.pk user behaviour.

## Dataset

There are two tables.

**sessions.csv** has 8,000 rows, one for each visit to the website. The columns are session_id, user_id, session_start, device and traffic_source.

**events.csv** has 25,201 rows, one for each page a visitor reached. The columns are event_id, session_id, event_time, step_order, page and time_on_page_sec.

The application funnel has eight steps: home, internship listing, apply click, signup, application form, CV upload, submit and confirmation. A visit that stops at an earlier step shows where that applicant left.

## Method

1. Loaded both CSV files into MySQL using MySQL Workbench.
2. Wrote nine SQL queries to measure the funnel, drop-off between steps, exit points, conversion by device, conversion by traffic source, time spent on the application form and daily applications. The queries use GROUP BY, JOIN, LEFT JOIN, CASE WHEN, a CTE and the LAG window function.
3. Exported the results and built a dashboard in Power BI.

## Key findings

- Out of 8,000 sessions, 778 reached the confirmation page. The overall conversion rate is 9.73%.
- 7,222 sessions ended without a completed application.
- The biggest drop in the funnel is between the application form and CV upload. Only 53.3% of the people who reached the form went on to CV upload, so 46.7% left at this step.
- The most common exit pages were the internship listing page (2,128 sessions) and the home page (2,006 sessions).
- Desktop users converted at 13.24% and mobile users at 7.80%.
- Among people who reached CV upload, 82.9% of desktop users went on to submit, compared with 69.0% of mobile users.
- Referral (14.06%) and LinkedIn (13.42%) had the highest conversion rates. Facebook was the lowest at 2.18%. Google brought the most applications (257), but its conversion rate was only 8.52%.
- The average time spent on the application form was almost the same for people who finished (149.9 seconds) and people who left (148.6 seconds). This means the data does not show that form length is the reason people leave.

## Recommendations

1. Look closely at the step between the application form and CV upload, since it has the largest drop.
2. Test the application form and CV upload on mobile phones, because mobile users convert less and drop more at CV upload.
3. Review the internship listing page to check whether the information and the Apply button are clear.
4. Check the Facebook campaigns, since that traffic rarely turns into applications, and put more effort into the sources that convert well.
5. Do not shorten the form only because of drop-off, because this analysis does not show a link between form time and leaving.

## Limitations

- The data is simulated, so the findings only show the method and are not real results.
- The data shows where people leave, but not why. Real user testing or surveys would be needed to find the reasons.
- The analysis covers about two months of simulated visits and has no checks for bots or repeat visitors.

## Files in this repository

- `sessions.csv` and `events.csv`: the simulated datasets
- `internee_queries.sql`: the SQL queries used
- `screenshots/`: query results and the Power BI dashboard
- `README.md`: this file

## Tools used

MySQL, MySQL Workbench, Power BI, Python (to generate the sample data)

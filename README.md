## Silvies Valley Ranch Collaborating Across Boundaries Project
<b>Course:</b> Database Systems <br>
<b>Stake Holder:</b> Silvies Valley Ranch <br>
<b>Group Members:</b> Brielle Damiani, Noverah Adeen, Elizabeth Burns <br>
<br>
<b>Project Title: </b> Goat Database for [Sylvies Farm](https://silvies.us/) <br>
<br>
### Project Overview
This project is a collaboration between Silvies Valley Ranch and students from a Database Systems course. Our aim is to develop a comprehensive database system tailored to the needs of Silvies Farm, focusing on goat data management. Our Group explored two research questions, one provided by the stake holder and another proposed by our own interests.
<br>
### Stakeholder Topic
<b>Progeny Report:</b> Our database system will provide a detailed progeny report, allowing stakeholders to easily navigate and understand the relationships between kids and dams.
<br>
### Group 13 Individual Topic
<b>Optimal Birthdate:</b> One of the key features of our database will be the ability to determine the optimal birthdate for breeding goats. By analyzing various factors, we aim to provide insights into the best time to breed goats for maximum efficiency and sustainability.
<br>
### Project Impact
<b>Sustainability:</b> Silvies Farm is dedicated to promoting sustainability in farming practices. Goats are recognized as more sustainable than cows, and by focusing on the American Range Goat, Silvies aims to mitigate the negative impacts associated with traditional cattle farming. Our database system aligns with this mission by providing tools and insights to support sustainable goat breeding and management practices. By exploring both these research questions our team will be able to aid Silvies Ranch in breeding the optimal American Range Goat.
<br>
### Diagrams
* [ER Diagram](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/ER_diagram.png)
* [Relational Schema](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/Relational_Schema.png)
* [Use Case](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/Usecase.png) 

## The UI:
* [Installation Guide](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/installation_guide.md)
* Team 13 utilized the template provided by Professor John Degood's flask7dbs repository and added some simple HTML and CSS styling <br>

![homepage1.png](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/UI/homepage.png)
![homepage2.png](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/UI/homepage2.png)
![homepage3.png](https://github.com/TCNJ-degoodj/project-group13/blob/main/docs/UI/homepage3.png)
<br>
## Explanation of the Queries
### 1. Progeny Report Queries 
#### Query 1
Query 1: Find all the Kids belonging to a specific Dam
- User Input: Specfic Dam Tag
- Output in a list of the Dam's Kids' information (Tag, Sex, DOB)
- Checkbox feature additionally shows birthweight, weaning weight, and sale weight
- Rationale: Being able to see all the kids to a specfic dam is important to the progeny report
#### Query 2
Query 2: Find all kids beloning to one sire
- User input: Specfic Sire Tag
- Check box feature see birthweight, weaning weight, and sale weight if applicable
- Similar to the dam query, but also important because sires are able to father a lot of children
#### Query 3
Query 3: Find all Dam info for dams with a specified number of kids
- User Input: Range, Min number of Kids and Max Number of Kids
- Rationale: While our first 2 queries only allow one dam or sires info at a time, and result in multiple goats, this query shows a lot of dams at once so you can compare their stats
- Stats Included: average birthweight, average weaning weight, average sale weight, total number of kids, number of stillborns, and how many total births
- Filtering by number of kids allows the user to pick and choose if they would only like to see dams with a lot of kids, or the ones that only had few children, or can even see a wide range
- The Checkbox feature allows the user to see the more recent dams at the top

### Optimal Date of Birth Queries
#### Query 4
Query 4: Find all the gaots born on a specific day
- Entering the desired month and day results in all the goats born on that day over all years
- Rationale: Looking for the best day independent of the year so viewing all the kids born on specfic days and how many there are is important in finding the relvant date of birth

#### Query 5
Query 5: Find all Goats born in a specfic date range
- Input: a range of days
- Rational: 

#### Query 6
Query 6: Find stats of particular days by entering months and year
- Input a particular month and day
- Output: every day's number of stillborns, number of kids, average bith weight, average weaning weight

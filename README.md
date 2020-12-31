# MySQL
This repository includes about my Database experiences which are coded on MySQL.

I worked different basic studies with MySql. 

Finally, I worked in detail on a large data set.

1- Explain your data:

● What’s the purpose of your project?
Our data is about US accidents, the purpose of this project is to parse this data and generate
useful reports for a variety of sections that can be analyzed using the sum of the accidents in
this dataset, and identify which locations are most relevant to the dataset and which ones
reduced the amount of accidents in a what timeframe as well as the average distances
covered in addition to many other results.

● How many files exist?
There is currently a single file for the whole dataset. As a start, the data was separated into
two entities though and I’m exploring how much more it can be abstracted from here.

● How many rows and columns do they contain?
There are about 3 million rows and 49 columns total

● https://www.kaggle.com/sobhanmoosavi/us-accidents/data  (Dataset)

● https://bitbucket.org/U170709055/dblab2020/src/master/proje/

2- Give a reasonably comprehensive and representative list of the English questions
you would like your system to be able to answer (find at least 10 questions).

      1. What is the maximum distance covered in an accident?
          333.630004883 miles
      2. Which city has the highest number of accidents?
          Houston with 93289 accidents
      3. Which weather condition caused the most accidents?
          Clear weather, with 2974335 accidents
      4. What is the number of accidents based on the US/Eastern timezone?
          1277187 accidents
      5. Which temperature has the most accidents?
          77 F or 25 C, with 66248 accidents
      6. How many accidents severity is 4?
          92337 accidents
      7. How many accidents start between 8 and 9am?
          284274 accidents
      8. Which day has the most accidents?
          2019-12-04, with 4882
      9. Which side has the most number of accidents?
          Right side, with 2438139 accidents
      10. Which location has the most accidents?
          The one with the zip code 91706
    
3- Design and show a relational data model (ER diagram) that you plan to use for your
system.
      You can find in PROJECT source code.

4- Write the SQL statements that will implement the English questions from
your target queries (from Question 3). You will need to provide at least 1
aggregate function with group by.

      1- What is the maximum distance covered in an accident?
          SELECT max(distance)
          FROM Accident;
      2- Which city has the highest number of accidents?
          SELECT city, count(*) NumberOfAccidents
          FROM Airport group by City
          order by NumberOfAccidents desc limit 1;
      3- Which weather condition caused the most accidents?
          SELECT Weather_Condition, count(*) NumberOfCondition
          FROM Weather group by Weather_Condition
          order by NumberOfCondition desc limit 1;
      4- What is the number of accidents based on the US/Eastern timezone?
          SELECT Timezone, count(*)
          FROM Accident
          where Timezone = 'US/Eastern';
      5- Which temperature has the most accidents?
          SELECT Temperature_F, count(*) NumberOfAccidents
          FROM Weather group by Temperature_F
          order by NumberOfAccidents desc limit 1;
      6- How many accidents severity is 4?
          SELECT count(*) NumberOfAccidents
          FROM Accident
          where Severity = 4;
      7- How many accidents start between 8am and 9am?
          SELECT count(*) NumberOfAccidents
          FROM Accident
          WHERE hour(Start_Time) between 8 and 9;
      8- Which day has the most accidents?
          SELECT date(Start_Time) theDay, count(*) accidentsNumber
          FROM Accident
          group by theDay
          order by accidentsNumber desc limit 1;
      9- Which side has the most number of accidents?
          SELECT Side, count(*) NumberOfAccidents
          FROM Accident group by Side
          order by NumberOfAccidents desc limit 1;
      10- Which location has the most accidents?
          SELECT substring_index(Zipcode, '-', 1) theZipCode, count(*)
          accidentsNumber
          FROM Accident GROUP BY theZipCode
          order by accidentsNumber DESC limit 1;
          
5- Provide a proposal of how you will load the database with values. — If you plan to
extract/import data from on-line sources, briefly describe what are the sources (e.g.
personal data, or WWW URL's) and what any format conversion issues you expect to
encounter are. — If you plan to input your data primarily through a WWW or
form-based inter-face, briefly describe this interface and the issues involved.

I plan to deploy the database to a Linux Virtual Machine on an online cloud such as
Linode, with 1GB of RAM and 1 virtual CPU of whatever CPU line they’re using for their
servers. To import the data I’m gonna use the CSV file and use a modified version of this
script that imports the data to the database directly by making a connection and creating
insert queries. For the moment, I’ve used the file to extract a portion of the dataset in order
to test the queries I’ve created:

        const readline = require('readline');
        const fs = require('fs');
        const readInterface = readline.createInterface({
        input: fs.createReadStream('US_Accidents.csv'),
        output: process.stdout,
        console: false
        });
        let mainLine;
        readInterface.on('line', function (line) {
        let arr = line.split(',');
        let currLine = {};
        if (arr[0] == 'ID')
        mainLine = arr;
        else if (arr[0] != 'ID') {
        for (let i = 0; i < mainLine.length; i++) {
        currLine[mainLine[i]] = arr[i];
        }
        doline(currLine);
        }
        });
        let count = 1;
        let savedAirports = {};
        doline = line => {
        line = JSON.parse(JSON.stringify(line))
        line['ID'] = parseInt(line['ID'].replace('A-', ''));
        console.log(line);
        let accident = [];
        accident.push(line['ID'] || 'NULL');
        accident.push(line['Source'] || 'NULL');
        accident.push(line['TMC'] || 'NULL');
        accident.push(line['Severity'] || 'NULL');
        accident.push(line['Start_Time'] || 'NULL');
        accident.push(line['End_Time'] || 'NULL');
        accident.push(line['Start_Lat'] || 'NULL');
        accident.push(line['Start_Lng'] || 'NULL');
        accident.push(line['End_Lat'] || 'NULL');
        accident.push(line['End_Lng'] || 'NULL');
        accident.push(line['Distance(mi)'] || 'NULL');
        accident.push(line['Description'] || 'NULL');
        accident.push(line['Number'] || 'NULL');
        accident.push(line['Street'] || 'NULL');
        accident.push(line['Side'] || 'NULL');
        accident.push(line['Zipcode'] || 'NULL');
        accident.push(line['Timezone'] || 'NULL');
        accident.push(line['Airport_Code'] || 'NULL');
        accident.push(count);
        accident.push(count);
        let airport = [];
        airport.push(line['Airport_Code'] || 'NULL');
        airport.push(line['City'] || 'NULL');
        airport.push(line['Country'] || 'NULL');
        airport.push(line['County'] || 'NULL');
        airport.push(line['State'] || 'NULL');
        let environment = []
        environment.push(count);
        environment.push(line['Amenity'] == true);
        environment.push(line['Bump'] == true);
        environment.push(line['Crossing'] == true);
        environment.push(line['Give_Way'] == true);
        environment.push(line['Junction'] == true);
        environment.push(line['No_Exit'] == true);
        environment.push(line['Railway'] == true);
        environment.push(line['Roundabout'] == true);
        environment.push(line['Station'] || 'NULL');
        environment.push(line['Stop'] == true);
        environment.push(line['Traffic_Calming'] == true);
        environment.push(line['Traffic_Signal'] == true);
        environment.push(line['Turning_Loop'] == true);
        environment.push(line['Sunrise_Sunset'] || 'NULL');
        environment.push(line['Civil_Twilight'] || 'NULL');
        environment.push(line['Nautical_Twilight'] || 'NULL');
        environment.push(line['Astronomical_Twilight'] || 'NULL');
        let weather = [];
        weather.push(count++);
        weather.push(line['Weather_Timestamp'] || 'NULL');
        weather.push(line['Temperature(F)'] || 'NULL');
        weather.push(line['Wind_Chill(F)'] || 'NULL');
        weather.push(line['Humidity(%)'] || 'NULL');
        weather.push(line['Pressure(in)'] || 'NULL');
        weather.push(line['Visibility(mi)'] || 'NULL');
        weather.push(line['Wind_Direction'] || 'NULL');
        weather.push(line['Wind_Speed(mph)'] || 'NULL');
        weather.push(line['Precipitation(in)'] || 'NULL');
        weather.push(line['Weather_Condition'] || 'NULL');
        fs.appendFile('Accident.csv', accident.join(',') + '\n', err => {
        });
        if (!savedAirports[airport[0]]) {
        savedAirports[airport[0]] = true;
        fs.appendFile('Airport.csv', airport.join(',') + '\n', err => {
        });
        }
        fs.appendFile('Weather.csv', weather.join(',') + '\n', err => {
        });
        fs.appendFile('Environment.csv', environment.join(',') + '\n', err => {
        });
        }
        
And just after that, I’m gonna create a REST API service with Java, C#, NodeJS or
something similar. Most likely C# or NodeJS due to their non-blocking async features which
can be really helpful in a single vCPU senario just like this one, but since there won’t be
much load, I might as well use Java and a small threadpool as that wouldn’t be much of a
bottleneck for a small amount of requests.

6- Very briefly describe a type of reports you plan to generate or any special user
interface issues (e.g. views/stored procedures or GUI?) that you plan to implement.

I plan to create a web front-end that connects to our REST API in order to perform its
multitude of functions. The idea is for the user to select the city they’re traveling from, the city
they’re traveling to, the start and the end time of the flight in order to see the history of the
accidents, their amount, where exactly they happened, etc. Along with other options such as
finding the locations that had a relatively high amount of accidents, etc.

The end goal is to create a map with the accidents that happened between two dates that
the user can select, adding a line from and to each of the states that the flights which had
accidents had as a route, and the lines becoming deeper in color relative to the amount of
accidents happened in those locations.

7- Describe the database platform you plan to use (i.e. MySQL 5.0 on your
home computer Pentium II with 26 MB of memory, etc.), including any
relevant implementation details or challenging issues.

It’s gonna be hosted on a cloud service as a virtual server, with 1vCPU of
whatever is offered at the time as well as 1GB of ram and around 20GB of
storage, I can also added on a virtual server that we currently use for a personal
project as well in order to avoid the extra costs and it won’t be much of a hassle
since there isn’t gonna be any huge loads on either the database or the REST api
service I’m creating.

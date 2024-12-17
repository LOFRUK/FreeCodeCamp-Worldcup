#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")



cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT GWINNER GOPPONENT
do 
  if [[ $YEAR != "year" ]]
  then

    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");


    if [[ -z $TEAM_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_MAJOR_RESULT == "INSERT 0 1" ]]
        then
         echo Inserted into teams, $WINNER
       fi

       TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");
     fi
   
      if [[ $YEAR != "year" ]]
      then
      
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
        
        
        if [[ -z $TEAM_ID ]]
        then
          INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
          then
            echo Insert into teams, $OPPONENT
          fi

        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
      
    
    
      fi
      if [[ $YEAR != "year" ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");

        INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $GWINNER, $GOPPONENT)")
        if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $GWINNER $GOPPONENT
        fi
      fi  
    fi
  fi  
done
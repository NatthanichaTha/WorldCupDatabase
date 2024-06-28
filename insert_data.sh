#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#echo $($PSQL "TRUNCATE TABLE games, teams")

### insert all the teams into teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then 
    #get winner & opponent team id 
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if winner team id not found 
    if [[ -z $WINNER_TEAM_ID ]]
    then
      #insert winner team to teams table 
      INSERT_WINNER_TEAM_RES=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM_RES == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi

    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      #insert opponent team to teams table 
      INSERT_OPPONENT_TEAM_RES=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM_RES == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi

  fi
done

##insert game infos into games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #get winner & opponent team id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $WINNER_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo $OPPONENT_ID
    #insert year, round, winner_id, opponent_id, winner_goals, opponent_goals
    INSERT_GAME_INFO_RES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_INFO_RES == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi
done
#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

# insert teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  # get winner team names
  if [[ $WINNER != "winner" ]]
  then
    WINNER_NAMES=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    # if no record found
    if [[ -z $WINNER_NAMES ]]
    then
      # insert teams
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi

      # get new winner team names
      WINNER_NAMES=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    fi
  fi

  # get opponent team names
  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_NAMES=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    # if no record found
    if [[ -z $OPPONENT_NAMES ]]
    then
      #insert teams
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi

      # get new opponent team names
      OPPONENT_NAMES=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    fi
  fi
done

# insert games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # insert game records
    INSERT_GAME_RECORD=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")
    if [[ $INSERT_GAME_RECORD == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS
    fi
  fi
done
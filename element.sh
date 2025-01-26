#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is not empty and is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then 
    # use the symbol or name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1' OR name = '$1'")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1' OR name = '$1'")
  else
    # use atomic number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    # get the element properties 
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

    echo "The element with atomic number $(echo "$ATOMIC_NUMBER" | sed -r 's/^ *| *$//g') is $(echo "$ELEMENT_NAME" | sed -r 's/^ *| *$//g') ($(echo "$ELEMENT_SYMBOL" | sed -r 's/^ *| *$//g')). It's a $(echo "$TYPE" | sed -r 's/^ *| *$//g'), with a mass of $(echo "$ATOMIC_MASS" | sed -r 's/^ *| *$//g') amu. $(echo "$ELEMENT_NAME" | sed -r 's/^ *| *$//g') has a melting point of $(echo "$MELTING_POINT" | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo "$BOILING_POINT" | sed -r 's/^ *| *$//g') celsius."
  fi
fi

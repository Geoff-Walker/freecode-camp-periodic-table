#! /bin/bash
## Set connection   
PSQL="psql --csv --username=freecodecamp --dbname=periodic_table --tuples-only -c"
## If no argument is given, print and exit
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 1
else
    ## If argument is a number get element by atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1;")
    ## If argument is a string get element by symbol or name
  else
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1';")
  fi
    ## If no element is found, print and exit
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
    ## If element is found, print
  else
    IFS=',' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< $ELEMENT
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
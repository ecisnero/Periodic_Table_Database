#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # If first argument is numeric
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    element=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1;")
  # If first argument is 2 characters in length
  elif [[ ${#1} -le 2 ]]
  then
    element=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1';")
  fi
  echo $element | while IFS='|' read atomic_number symbol name atomic_mass melting_point boiling_point type
    do
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    done
fi

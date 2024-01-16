% Define parent-child relationships.
parent(john, doug).
parent(pam, doug).
parent(tom, liz).
parent(pam, liz).

% Define male and female.
male(john).
male(doug).
female(pam).
female(liz).

% Define a rule for 'father'.
father(Father, Child) :- 
    male(Father),
    parent(Father, Child).

% Define a rule for 'mother'.
mother(Mother, Child) :- 
    female(Mother),
    parent(Mother, Child).

% Define a rule for 'sibling'.
sibling(Person1, Person2) :- 
    parent(Parent, Person1),
    parent(Parent, Person2),
    Person1 \= Person2.


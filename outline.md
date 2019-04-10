Main talk - Sprinkles of functional programming

Often in Rails apps there is a need to accomplish tasks where we are less interested in modeling domain concepts as collections of related objects and more interested in transforming or aggregating data. Instead of forcing object oriented design into a role that it wasn’t intended for, we can lean into ruby’s functional capabilities to create Rails apps with sprinkles of functional code to accomplish these tasks.

Some tasks in production software can and should be handled with a more functional style. Let's learn what types of tasks lend themselves to a functional style and how to write clear and maintainable ruby to accomplish such tasks.

intro

examples
- csv importer

1. Basic Importer
2. Proper routes with imports controller / imports service object


basic data
add a few more fields
add support for multiple formats (csv, xlsx)
add support for reading from an ftp
add data validations with a validator
add data transformations

- data reporter
basic data reading

understand task first, then choose style
what do you expect will change? Data, or Behaviour? if data, consider a
functional style, if behaviour, consider object oriented.

Intent matters

fundamentals are worth revisiting, are worth practicing

task driven development - avoid ideology

Don't sweep complexity under the rug. Endeavor to make things less complex, not
just nicer looking. (It's okay to have mess sometimes, it's less okay to try and
hide that.)

what do we mean when we say functional
function signatures
blocks assembly code that have a name, live in the context of a call stack
the existence of higher order functions?
data pipelines


Where does this apply?

The two easy ones.
data transformations
data aggregations
data streaming
data templating

mutations
yield self / then
map
reduce


what are the paradigm smells: how do you know you've picked the wrong paradigm?
-> divergent changes
-> shotgun surgery
-> lots of hiding complexity moments, when what you're doing isn't really that
complex
-> lots of classes that end in 'er'


what are the process smells: how do you know your process could be improved?


---

1. ruby is a general purpose language.

2. not all automation tasks are the same.

3. Behavior -> OO, Data -> FP

4. We should choose our style based off our task

---

Dependency structure

- it might me nice to give a few strategies to apply functional styles to your code.

- what are the benefits, you write less code, you have more flexible code, more
  clear, reduces the maintenance, less places for bugs, easier to test.


- tell a story of receive a request for users to upload a CSV
- potential questions to ask about the work to help decide your approach
g are other customers likely to want this feature?
- do we need to support multiple formats?


"Good code is code that is easy to change" -quote.

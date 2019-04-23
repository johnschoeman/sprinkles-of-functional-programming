footer: © thoughtbot

# Sprinkles of Functional Programming

---

Hello I'm John,

I work at

![100%](./images/tb_horizontal_default.png)

---

<br/>
<br/>
<br/>

- Github: /johnschoeman
- Twitter: @john\_at\_aol\_dot\_com\_at\_gmail\_dot\_com

---

### Roadmap

- Key Thesis
- A Bit about FP and OO
- A Recommendation
- A Story with Some Code
- Retro / Action Items
- Questions

---

## Key Thesis

---

<br/>

### Ruby
is a general purpose language.

^ it is excellent with both object oriented programming and functional
programming. the developer gets to choose

---

```ruby
Object.new
```

```ruby
-> (x) { |x| x + 1 }
```

---

<br/>

### Different Paradigms
lend themselves to different tasks.

^ some times we want to model some real world interactions, create things that
represent a useful thing. sometime we want take some information from point a to point b, sometimes we
want to ask some quantitative question of some data.



---

<br/>
<br/>

OO -> Behavior

<br/>

FP -> Data

---

<br/>

### We should choose
our progamming style based off the task at hand.
Doing so will lead to a better product.

^  Some automation tasks lend themselves to an object oriented solution, some to a
   functional solution.
  - Sometimes it makes sense to program ruby in an object oriented way
  - other times it makes sense to program ruby in a functional way.
  - It depends on the task.
  - (you may now leave)

---

<br/>
<br/>

If you are modeling behavior
prefer classes and composition.

<br />

If you are handling data,
prefer data pipelines and folds.

---

<br/>

## A Bit about FP and OO

---

<br/>

### Objects and Functions
are a useful distinction.

^ explain what you mean by fp
it's not a precise term, it means some different depending on who you're talking
to 
 functions are at the forefront
 avoiding mutation
 avoiding side effects

---

<br/>

### What is difficult to change
is perhaps a better distinction.

---

 `-` | Add new method | Add new Data
---|---|---
OO | Existing code unchanged | Existing code changed
FP | Existing code changed | Existing code unchanged

---

### OO Typical cases

- Resource modeling
- Behaviour modeling
- State modeling

---

### FP Typical cases

- Data transformations
- Data aggregates
- Data streaming
- Data templating

---

## A Recommendation

---

<br/>

### Given
that methods are easy to change in OO
and data are easy to change in FP

---

<br/>

### Ask
how you expect requirements
will change before beging a task.

^
  A good way to decide which task goes to which is by asking what is more
  likely to change in the future of your program, the behavior, or the data?
  thus given a task you're solving with programming, if you expect behavior to
  change, prefer object oriented. If you expect data to change, prefer functional programming

---

<br/>

### Base
this question off the context of your business
and what users might want.

---

<br/>

## A Story
with some code

---

### Imagine a Rails App

^ explain the app: a generic rails product monolith, there are users, which have
things, and can do things, say a b to b of medium to largish size.

^ explain the problem: users would like to migrate to the app, they need to upload
their spreadsheets to the app, we need to ingest those spreadsheets, save the
rows for the users as active record objects. They'd like to upload the
spreadsheets to an ftp server and we'll poll it every day to import the files.

^ Lets call this product...

---

### Initial Requirement

^
1. rake task to poll the data - iterate over the files in the ftp server, kick
   off background worker
2. worker: call importer class - iterate over the rows, save to the database
3. success

---

### New Requirement

---

### And so on...

---

## Retro / Action Items

---

<br/>

- Initial Requirement: Clients Import CSV
-  New Requirement: .xlsx + .csv
-  New Requirement: New Client, New Format
-  New Requirement: Data Validations

^
new requirements from the sales team. they want csv and excel (and they
apparently can't just export excel to csv)

---

### Take Away - Code Quality

---

## Benefits
of chosing the right paradigm for the task

- Less Code
- Easier to Test
- More Flexible
- More Honest

^ This is why your life may be better if you choose these approaches

---

## Paradigm Smells
Using OO for a task
that lends itself to FP

- divergent changes
- shotgun surgery
- lots of collaborator mocking
- having to open many files to understand one task
- lots of 'something-er' classes
- UML is a linked list

---

![50%, left](./images/03.png)

---

### Take Aways - Process

---

<br/>

### It's Useful
to consider the what about the task you expect to change

---

<br/>

### Sprinkles,
just a little goes a long way

^ The majority of what we want to do in our Rails apps is concerned with
behavior, so we would expect that most of our applicaiton code will be classes
and object, thats our models, sevice objects, controllers, but sometimes we have
other task that needs to be done which would lend themselves to a funcitonal
style, but it would be a mistake to try to do everything in a functional style.

---

<br/>

### Be Conscientious
of buisness goals before starting work.

^ It's only helpful to pick one paradigm over the other when we know something is
is likely to change and in what way it will change. If you're not considering
the bigger picture, you're at risk of choosing poorly.

---

## Action Items

1. Understand your task before you choose style
2. Ask what do you expect will change?
3. Data or Behaviour?
4. if Data, consider a functional style
5. if Behaviour, consider a object oriented style

---

## Thesis

- Given Ruby is a general purpose language.
- And different paradigms lend themselves to different tasks
- We should choose our style based off of our task

---

### Repo:

Code:

johnschoeman/sprinkles-of-functional-programming-app

Slides:

johnschoeman/sprinkles-of-functional-programming

---

## Questions

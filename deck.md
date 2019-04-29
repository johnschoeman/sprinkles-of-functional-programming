footer: johnschoeman

# Sprinkles of Functional Programming

---

Hello, I'm John
I work at

![original, 100%](./images/tb_horizontal_default.png)

---

<br/>
<br/>
<br/>

- Github: /johnschoeman
- Mastadon: johnschoeman@technology.social
- Twitter: @john\_at\_aol\_dot\_com\_at\_gmail\_dot\_com

^ Dont ramble on the joke

---

### Roadmap

- Thesis
- FP and OO
- A Recommendation
- A Story with Some Code
- Recap / Action Items
- Questions

^ not here to teach functional programming specifically.

---

## Thesis

---

<br/>

### Ruby
is a general purpose language

^ it is excellent with both object oriented programming and functional
programming. the developer gets to choose

---

<br/>

```ruby
class A < B
Object.new
define_method(:foo)
```

<br/>

```ruby
-> (x) { |x| x + 1 }
data.map
yield_self / then
```

---

<br/>

### Different paradigms
lend themselves to different tasks

^ some times we want to model some real world interactions, create things that
represent a useful thing. Sometimes we want take some information from point a to point b, sometimes we
want to ask some quantitative question of some data.

---

<br/>

### OO -> Behavior

<br/>

### FP -> Data

---

<br/>

### We should choose
our programming style based off the task at hand

^ Doing so will lead to a better product.

^  Some automation tasks lend themselves to an object oriented solution, some to a
   functional solution.
  - Sometimes it makes sense to program ruby in an object oriented way
  - other times it makes sense to program ruby in a functional way.
  - It depends on the task.
  - (you may now leave)

---

<br/>
<br/>

If you are modeling *behavior*,
prefer *classes* and *composition*.

<br />

If you are handling *data*,
prefer *data pipelines* and *folds*.

---

## FP and OO

---

<br/>

### Objects and functions
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

 | *New Method* | *New Data*
---|:---|:---
*OO* | Existing code unchanged | Existing code changed
*FP* | Existing code changed | Existing code unchanged

---

### OO Typical Cases

- Resource modeling
- Behaviour modeling
- State modeling

---

### FP Typical Cases

- Data transformations
- Data aggregates
- Data streaming

---

## A Recommendation

---

<br/>

### Given
that methods are easy to add in OO
and data is easy to add in FP

---

<br/>

### Ask
how you expect requirements
will change before beginning a task.

^
  A good way to decide which task goes to which is by asking what is more
  likely to change in the future of your program, the behavior, or the data?
  thus given a task you're solving with programming, if you expect behavior to
  change, prefer object oriented. If you expect data to change, prefer functional programming

---

<br/>

### Base
this question off the context of your business
and what users might want

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

![](./images/create_a_product.mov)

---

### Initial Requirement
Allow users to upload a csv

---

### Initial Requirement

---

#### Commit 0

```
Allow users to upload csv of products
```

---

[.code-highlight: all]
[.code-highlight: 3]
[.code-highlight: 5]
[.code-highlight: 6]
[.code-highlight: 8]

```ruby

RSpec.describe "User uploads a file of produce data" do
  scenario "by visiting the root page and clicking 'upload file'" do
    visit root_path

    attach_file("file", Rails.root.join("spec/fixtures/products.csv"))
    click_on "Upload File"

    expect(Product.count).to eq 3
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 3]

```ruby
class ImportsController < ApplicationController
  def create
    Product.import(params[:file].path)
    redirect_to products_path, notice: "Succesfully imported"
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4]
[.code-highlight: 6]
[.code-highlight: 8]

```ruby
  describe ".import" do
    context "the file is a csv" do
      it "saves every row in the file as new product" do
        filepath = stub_csv

        Product.import(filepath)

        expect(Product.count).to eq 3
      end
    end
  end
```

---

[.code-highlight: all]
[.code-highlight: 3-9]

```ruby
class Product < ApplicationRecord
  validates :name, presence: true

  def self.import(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      data = row.to_h.symbolize_keys
      data[:title] = data[:title].titleize
      data[:release_date] = Time.zone.parse(data[:release_date])
      create(data)
    end
  end
end
```

---

```
- app
  - controllers
     imports_controller.rb
  - models
    - product.rb
```

---

```
- spec
  - fixtures
    - products.csv
  - features
    - user_uploads_a_products_file_spec.rb
  - models
    - product_spec.rb
```

---

### Initial Requirement
#### Gif

---

![](./images/upload_csv.mov)

---

### New Requirement
csv + xlsx

---

[.code-highlight: 2]

#### Commit 1

```
Allow users to upload csv of products
Introduce product data importer
```

---

[.code-highlight: all]
[.code-highlight: 3]
[.code-highlight: 4]
[.code-highlight: 6]
[.code-highlight: 8]

```ruby
RSpec.describe ProductDataImporter
 it "saves every row in the file as new product" do
    filepath = stub_csv
    importer = ProductDataImporter.new(filepath)

    importer.import

    expect(Product.count).to eq 3
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-6]
[.code-highlight: 18-13]

```ruby
class ProductDataImporter
  attr_reader :filepath

  def initialize(filepath)
    @filepath = filepath
  end

  def import
    CSV.foreach(filepath, headers: true) do |row|
      data = row.to_h.symbolize_keys
      data[:title] = data[:title].titleize
      data[:release_date] = Time.zone.parse(data[:release_date])
      Product.create(data)
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 3]
[.code-highlight: 4]

```ruby
class ImportsController < ApplicationController
  def create
    importer = ProductDataImporter.new(params[:file].path)
    importer.import
    redirect_to products_path, notice: "Succesfully imported"
  end
end
```

---

[.code-highlight: 3]

#### Commit 2

```
Allow users to upload csv of products
Introduce product data importer
Introduce product data formatter
```

---

[.code-highlight: all]
[.code-highlight: 2]
[.code-highlight: 5]
[.code-highlight: 6]
[.code-highlight: 8]

```ruby
Rspec.describe ProductDataFormatter
  it "builds a data hash from a csv_row for the product" do
    headers = %w[name author version release_date value active]
    fields = %w[name_a author_a 1.10.3 20190101 100 true]
    csv_row = CSV::Row.new(headers, fields)
    formatter = ProductDataFormatter.new

    result = formatter.build(csv_row)

    expect(result).to eq(expected_results)
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 2-7]

```ruby
class ProductDataFormatter
  def build(csv_row)
    data = csv_row.to_h.symbolize_keys
    data[:title] = data[:title].titleize
    data[:release_date] = Time.zone.parse(data[:release_date])
    data
  end
end
```

---

[.code-highlight: 4]

#### Commit 3

```
Allow users to upload csv of products
Introduce product data importer
Introduce product data formatter
Allow .xlsx format for importer
```

---

[.code-highlight: all]
[.code-highlight: 3]

```ruby
Rspec.describe ProductDataImporter
  context "the file is a xlsx" do
    it "saves every row in the file as new product" do
      filename = "products.xlsx"
      stub_xlsx(filename)

      formatter = ProductDataFormatter.new
      importer = ProductDataImporter.new(filename, formatter)

      importer.import

      expect(Product.count).to eq 3
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-8]
[.code-highlight: 9-15]
[.code-highlight: 27-32]

```ruby
class ProductDataImporter
  attr_reader :filepath, :formatter

  def initialize(filepath, formatter)
    @filepath = filepath
    @formatter = formatter
  end

  def import
    case File.extname(filepath)
    when ".csv"
      import_csv
    when ".xlsx"
      import_xlsx
    end
  end

  private

  def import_csv
    CSV.foreach(filepath, headers: true) do |row|
      formatted_data = formatter.build(row)
      formatted_data = formatter.build_csv(row)
      Product.create(formatted_data)
    end
  end

  def import_xlsx
    Xlsx.foreach(filepath) do |row|
      formatted_data = formatter.build_xlsx(row)
      Product.create(formatted_data)
    end
  end

...
end


```

---

### New Requirement
New currency format $

---

[.code-highlight: 5]

#### Commit 4

```
Allow users to upload csv of products
Introduce product data importer
Introduce product data formatter
Allow .xlsx format for importer
Refactor importer
```

---

[.code-highlight: all]
[.code-highlight: 4]

```ruby
RSpec.describe CsvImporter
  describe "#import" do
    it "saves every row in the file as new product" do
      filename = "products.csv"
      stub_csv(filename)
      formatter = ProductDataFormatter.new
      importer = CsvImporter.new(filename, formatter)

      importer.import

      expect(Product.count).to eq 3
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-8]

```ruby
class CsvImporter
  attr_reader :filepath, :formatter

  def initialize(filepath, formatter)
    @filepath = filepath
    @formatter = formatter
  end

  def import
    CSV.foreach(filepath, headers: true) do |row|
      formatted_data = formatter.build_csv(row)
      Product.create(formatted_data)
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 3]

```ruby
RSpec.describe XlsxImporter
  describe "#import" do
    it "saves every row in the file as new product" do
      filename = "products.xlsx"
      stub_xlsx(filename)

      formatter = ProductDataFormatter.new
      importer = XlsxImporter.new(filename, formatter)

      importer.import

      expect(Product.count).to eq 3
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-8]

```ruby
class XlsxImporter
  attr_reader :filepath, :formatter

  def initialize(filepath, formatter)
    @filepath = filepath
    @formatter = formatter
  end

  def import
    Xlsx.foreach(filepath) do |row|
      formatted_data = formatter.build_xlsx(row)
      Product.create(formatted_data)
    end
  end
end
```

---

[.code-highlight: 6]

#### Commit 5

```
Allow users to upload csv of products
Introduce product data importer
Introduce product data formatter
Allow .xlsx format for importer
Refactor importer
Introduce file importer
```

---

[.code-highlight: all]
[.code-highlight: 3]

```ruby
RSpec.describe FileImporter
  describe "#import" do
    it "raise if called" do
      importer = FileImporter.new("filepath", double("formatter"))

      expect { importer.import }.to raise_error("Must overwrite method")
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-8]
[.code-highlight: 10-12]

```ruby
class FileImporter
  attr_reader :filepath, :formatter

  def initialize(filepath, formatter)
    @filepath = filepath
    @formatter = formatter
  end

  def import
    raise "Must overwrite method"
  end
end
```

---

```ruby
class XlsxImporter < FileImporter
  ...
end
```

```ruby
class CsvImporter < FileImporter
  ...
end
```

---

[.code-highlight: 7]

#### Commit 6

```
Allow users to upload csv of products
Introduce product data importer
Introduce product data formatter
Allow .xlsx format for importer
Refactor importer
Introduce file importer
Introduce data builder class
```

---

[.code-highlight: all]
[.code-highlight: 4]

```ruby
RSpec.describe ProductDataBuilder
  describe "#build" do
    it "raises" do
      formatter = double
      builder = ProductDataBuilder.new(formatter)

      expect { builder.build }.to raise_error("Must override method")
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-6]
[.code-highlight: 8-10]

```ruby
class ProductDataBuilder
  attr_reader :formatter

  def initialize(formatter)
    @formatter = formatter
  end

  def build
    raise "Must override method"
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4]
[.code-highlight: 5]

```ruby
RSpec.describe CsvBuilder do
  describe "#build" do
    context "when given a csv_row of product data" do
      it "creates a hash of the product data" do
        headers = %w[name author version release_date value active]
        fields = %w[name_a author_a 1.10.3 20190101 100 true]
        csv_row = CSV::Row.new(headers, fields)
        formatter = ProductDataFormatter.new
        builder = CsvBuilder.new(formatter)

        result = builder.build(csv_row)

        expect(result).to eq({ ...data })
      end
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 2-5]

```ruby
class CsvBuilder < ProductDataBuilder
  def build(csv_row)
    data = csv_row.to_h.symbolize_keys
    formatter.format(data)
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 3]
[.code-highlight: 4]

```ruby
RSpec.describe XlsxBuilder do
  describe "#build" do
    context "when given a xlsx_row of product data" do
      it "creates a hash of the product data" do
        headers = %w[name author version release_date value active]
        fields = %w[name_a author_a 1.10.3 20190101 100 true]
        xslx_row = stub_xslx_row(headers, fields)
        formatter = ProductDataFormatter.new
        builder = CsvBuilder.new(formatter)

        result = builder.build(xlsx_row)

        expect(result).to eq({ ...data })
      end
    end
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-7]

```ruby
class XlsxBuilder < ProductDataBuilder
  HEADERS = %w[name author release_date value version active].freeze

  def build(xlsx_row)
    cells = xlsx_row.cells.map(&:value)
    data = HEADERS.zip(cells).to_h.symbolize_keys
    formatter.format(data)
  end
end
```

---

[.code-highlight: 8]

#### Commit 7

```
Allow users to upload csv of products
Introduce product data importer
Introduce product data formatter
Allow .xlsx format for importer
Refactor importer
Introduce file importer
Introduce data builder class
Format currency data from csv
```

---

[.code-highlight: all]
[.code-highlight: 3]
[.code-highlight: 4]
[.code-highlight: 5]
[.code-highlight: 6]
[.code-highlight: 8]
[.code-highlight: 10]

```ruby
RSpec.describe ProductDataFormatter do
...
    context "when the currency has a dollar sign" do
      it "strips the dollar sign" do
        data = { value: "$1230" }
        formatter = ProductDataFormatter.new

        result = formatter.format(data)

        expect(result).to eq({ value: 1230 })
      end
    end
```

---

[.code-highlight: all]
[.code-highlight: 2-6]
[.code-highlight: 4]
[.code-highlight: 10-12]

```ruby
class ProductDataFormatter
  def format(data)
    data[:title] = format_title(data[:title])
    data[:release_date] = format_date(data[:release_date])
    data[:value] = format_currency(data[:value])
    data
  end

  ...

  def format_currency(input)
    input.to_s.gsub(/^\$/, "").to_i
  end
end
```

---

### New Requirement...

---

```
- app
  - models
    - application_record.rb
    - csv_builder.rb
    - csv_importer.rb
    - file_importer.rb
    - product.rb
    - product_data_builder.rb
    - product_data_formatter.rb
    - product_data_importer.rb
    - xlsx_builder.rb
    - xlsx_importer.rb
```

---

```
- spec
  - models
    - csv_builder_spec.rb
    - csv_importer_spec.rb
    - file_importer_spec.rb
    - product_spec.rb
    - product_data_builder_spec.rb
    - product_data_formatter_spec.rb
    - product_data_importer_spec.rb
    - xlsx_builder_spec.rb
    - xlsx_importer_spec.rb
```

---

### Functional Path

---

### New Requirement (xlsx + csv)

---

[.code-highlight: 2]

#### Commit 1

```
Allow users to upload csv of products
Introduce product importer service
```

---

[.code-highlight: all]
[.code-highlight: 4]
[.code-highlight: 5]
[.code-highlight: 8]
[.code-highlight: 10]
[.code-highlight: 11]
[.code-highlight: all]

```ruby
RSpec.describe ProductDataImporter do
  describe ".import" do
    it "takes a file and creates product data from the data" do
      filename = Rails.root.join("spec/fixtures/products.csv")
      importer = ProductDataImporter.new
      expected_data = { ...data }

      importer.import(filename)

      expect(Product.count).to eq 3
      expect_product_to_match(Product.last, expected_data)
    end
  end
```

---

[.code-highlight: all]

```ruby
class ProductDataImporter
  def self.import(filepath)
    new.import(filepath)
  end

  def import(filepath)
    CSV.foreach(filepath, headers: true) do |row|
      data = row.to_h.symbolize_keys
      data[:active] = data[:active] == "true"
      data[:release_date] = Time.parse(data[:release_date]
      Product.create(data)
    end
  end
end
```

---

[.code-highlight: 3]

#### Commit 2

```
Allow users to upload csv of products
Introduce product importer service
Introduce data pipeline
```

---

[.code-highlight: all]
[.code-highlight: 6-10]
[.code-highlight: 12-37]
[.code-highlight: all]

```ruby
class ProductDataImporter
  def self.import(filepath)
    new.import(filepath)
  end

  def import(filepath)
    read_file(filepath).
      map { |data| process_data(data) }.
      map { |data| Product.create(data) }
  end

  private

  def read_file(filepath)
    results = []
    CSV.foreach(filepath, headers: true) do |row|
      results << row.to_h.symbolize_keys
    end
    results
  end

  def process_data(data)
    process_date(data).
      then { |data| process_title(data) }
  end

  def process_title(data)
    title = data[:title]
    data[:title] = title.titleize
    data
  end

  def process_date(data)
    release_date = data[:release_date]
    data[:release_date] = Time.zone.parse(release_date)
    data
  end
end
```

---

[.code-highlight: all]
[.code-highlight: 4-8]
[.code-highlight: 5]
[.code-highlight: 6]
[.code-highlight: 7]
[.code-highlight: 14-17]
[.code-highlight: 15]
[.code-highlight: 16]
[.code-highlight: all]

```ruby
class ProductDataImporter
  ...

  def import(filepath)
    read_file(filepath).
      map { |data| process_data(data) }.
      map { |data| Product.create(data) }
  end

  private

  ...

  def process_data(data)
    process_date(data).
      then { |data| process_title(data) }
  end

  ...

end
```

---

[.code-highlight: 4]

#### Commit 3

```
Allow users to upload csv of products
Introduce product importer service
Introduce data pipeline
Allow for users to upload either xlsx or csv
```

---

[.code-highlight: all]
[.code-highlight: 3]
[.code-highlight: 5]

```ruby
RSpec.describe ProductDataImporter do
  ...
    context "when provided a xlsx file" do
      it "creates product data from the data" do
        filename = Rails.root.join("spec/fixtures/products.xlsx")
        importer = ProductDataImporter.new
        expected_data = { ...data }

        importer.import(filename)

        expect(Product.count).to eq 4
        expect_product_to_match(Product.last, expected_data)
      end
```

---

[.code-highlight: all]

```ruby
class ProductDataImporter
  ...

  def import(filepath)
    read_file(filepath).
      map { |data| process_data(data) }.
      map { |data| Product.create(data) }
  end

  private

  def read_file(filepath)
    case File.extname(filepath)
    when ".csv"
      read_csv(filepath)
    when ".xlsx"
      read_xlsx(filepath)
    end
  end

  def read_xlsx(filepath)
    results = []
    foreach_xlsx(filepath) do |row|
      cells = row.cells.map(&:value)
      data = HEADERS.zip(cells).to_h.symbolize_keys
      results << data
    end
    results
  end

  ...
end
```

---

### New Requirement (New client, new formats)

---

[.code-highlight: 5]

#### Commit 4

```
Allow users to upload csv of products
Introduce product importer service
Introduce data pipeline
Allow for users to upload either xlsx or csv
Format currency data from csv
```

---

```
- spec
  - fixtures
    - products.csv
    - products.xlsx
```

---

[.code-highlight: all]
[.code-highlight: 7]
[.code-highlight: 12-16]
[.code-highlight: all]

```ruby
class ProductDataImporter
 ...

 def process_data(data)
    process_date(data).
      then { |data| process_description(data) }.
      then { |data| process_currency(data) }
  end

  ...

  def process_currency(data)
    value = data[:value].to_s
    data[:value] = value.gsub(/^\$/, "").to_i
    data
  end
end
```

---

### Recap

- Initial Requirement: Clients Import CSV
- *and then* New Requirement: .xlsx + .csv
- *and then* New Requirement: New currency format
- *and then* a New Requirement...

---

## Benefits
of choosing the right paradigm for the task

1. Easier to Understand
2. Less Code
3. Easier to Test and Maintain
4. Higher Development Velocity

^ This is why your life may be better if you choose these approaches

---

### 1. Easier to Understand

---

[.code-highlight: all]
[.code-highlight: 3-5, 7-11]

```
- app
  - models
    - csv_builder.rb
    - csv_importer.rb
    - file_importer.rb
    - product.rb
    - product_data_builder.rb
    - product_data_formatter.rb
    - product_data_importer.rb
    - xlsx_builder.rb
    - xlsx_importer.rb
```

---

[.code-highlight: all]
[.code-highlight: 3-5, 7-11]

```
- spec
  - models
    - csv_builder_spec.rb
    - csv_importer_spec.rb
    - file_importer_spec.rb
    - product_spec.rb
    - product_data_builder_spec.rb
    - product_data_formatter_spec.rb
    - product_data_importer_spec.rb
    - xlsx_builder_spec.rb
    - xlsx_importer_spec.rb
```

---

[.code-highlight: all]
[.code-highlight: 5]

```
- app
  - models
    - product.rb
  - services
    - product_data_importer.rb
```

---

[.code-highlight: all]
[.code-highlight: 3, 4, 6]

```
- spec
  - fixtures
    - products.csv
    - products.xlsx
  - services
    - product_data_importer_spec.rb
```

---

### 2. Less Code

[Graph Goes Here]

Total Diff
OO: 25 files, 424 (+), 49 (-)
FP: 10 files, 132 (+), 37 (-)

Accumulated Diff
OO: 47 files, 625 (+), 250 (-)
FP: 13 files, 152 (+), 57 (-)

---

### 3. Easier to Test / Maintain

[Graph Goes Here]

Number of Public APIs added:
OO: 8
FP: 1

---

### 4. Higher Development Velocity

[Graph Goes Here]

Dev Time
OO: about a work day
FP: about an hour

---

## Paradigm Smells
Using OO for a task that lends itself to FP

1. Lots of 'Something-er' Classes
2. UML is a Linked List

---

### 1. Lots of 'Something-er' Classes

```
- app
  - models
    - csv_builder.rb
    - csv_importer.rb
    - file_importer.rb
    - product.rb
    - product_data_builder.rb
    - product_data_formatter.rb
    - product_data_importer.rb
    - xlsx_builder.rb
    - xlsx_importer.rb
```

---

### 2. UML is a Linked List

<br />

![original, 100%](./images/03.png)

---

## Take Aways

---

<br/>

### It's useful
to consider how requirements might change

---

<br/>

### Sprinkles,
just a little goes a long way

^ The majority of what we want to do in our Rails apps is concerned with
behavior, so we would expect that most of our applicaiton code will be classes
and object, thats our models, sevice objects, controllers, but sometimes we have
other task that needs to be done which would lend themselves to a funcitonal
style, but it would be a mistake to try to do everything in a functional style.

^ you don't have to get super in to functional programming a few basics will get
you far

---

<br/>

### Be conscientious
of business goals before starting work.

^ It's only helpful to pick one paradigm over the other when we know something is
is likely to change and in what way it will change. If you're not considering
the bigger picture, you're at risk of choosing poorly.

---

### Action Item

Ask how you expect requirements will change:
Data or Behaviour?

-  if Data, consider a functional style
-  if Behavior, consider a object oriented style

---

## Thesis

*Ruby* is a *multi-paradigm* language.
<br/>
*Different paradigms* lend themselves to *different tasks*
<br/>
We should *choose our style* based off of our *task*

---

### FP Learning Resources

- Destroy All Software - Functional Core, Imperative Shell
- thoughtbot.com/blog 
- Piotr Solnica - Blending Functional and OO Programming in Ruby

---

### Repo
johnschoeman/sprinkles-of-functional-programming-app

---

## Questions

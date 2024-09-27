# Pyme Admin

## Table of Contents
* [Overview](#overview)
* [Tech stack](#tech-stack)
* [Installation](#installation)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)

## Overview

Pyme Admin is a system that manages stock and sales, designed specifically for small businesses. It covers everything you need to keep your business organized:

* Logging customer sales and purchases to suppliers
* Keeping track of stock, both of products for sale and supplies for production
* Setting notifications to alert you when you're low on stock, or when your account balance with a supplier falls below a certain number
* Setting reminders to buy supplies or remember a special order for a customer
* Closing the register at the end of the day with a breakdown of all inflows and outflows
* Gathering statistics about sales and purchases, cost and revenue

## Tech stack

Pyme Admin is a Ruby on Rails 7 project that uses Bootstrap on frontend.

## Installation

These are the instructions to install Pyme Admin on Linux (specifically, Ubuntu 22.04 LTS). 

### Pre-requisites
Make sure you have already installed:
* Git
* Rbenv (Ruby 3.3.1)
* Curl
* Nodejs
* Yarn
* Rubygems
* SQlite (and pkg-config)
* Rails

### Installing Pyme Admin
1. Clone this repository to your computer.

    ```git clone https://github.com/CamilaUlmetePais/pyme-admin.git ```

2. Run bundle

    ` bundle install`

3. In the `config` directory, create a file named `local_env.yml`. In this file, declare the following variables:

    `COMPANY_NAME : "Name of your business"`

    `COMPANY_OWNER : "Name of the owner as per billing regulations"`

    `COMPANY_OWNER_CUIT : "Argentinian billing regulation number"`

    `COMPANY_ADDRESS : "Physical company address"`

    `COMPANY_PHONE : "Company phone number"`

    `RECEIPT_MESSAGE : "Statement to show in outflow receipts"`

    `PURCHASE_MESSAGE : "Statement to show in purchase receipts, usually thanking customer for their purchase"`

4. Set up the database

    ` rails db:create`

    ` rails db:migrate`

    ` rails db:seed`

5. Run yarn
  
  ` yarn run build:css `

6. Installation is complete! You should be able to run the local server without issue. 

## Project Documentation 

PymeAdmin is currently being documented using YARD. To generate the documentation, follow these steps: 

1. (For Debian/Ubuntu users) make sure you have RDoc installed: 

  ` which RDoc `

If this turns up empty, install RDoc:

  `$ sudo apt-get install rdoc`

2. Run the YARD server

  ` yard server `

3. Now you'll be able to look at the project documentation at http://localhost:8808

### Notes

- Throughout the documentation, the following terms are used:

  - **User/s --**  The owner and any employees of the company using the app.
  - **Client/s --** The person/people buying goods and services from the company.

- The methods within models and controllers are alphabetized. 

<!-- working on

### Running tests

## Usage

## Contributing

## License 

* System dependencies

* Configuration

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions


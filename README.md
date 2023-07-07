# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version - 3.0.0

* System dependencies

* Configuration
  Add values for below ENV variables - DBUSER, DBPASS

* Database creation - PostGRESql. Run `rake db:migrate`.

* Database initialization - PostGRESql. Run `rake db:seed`

* Services - API to show processed logs

* Deployment instructions - Run `rails s`

* Implementation
  The log dataset is taken from this link [JSON Log Dataset](https://github.com/alexa/alexa-with-dstc10-track2-dataset/blob/main/task2/data/test/logs.json) and is in the below format: 
  [
    [
      {
        'speaker': <U/S>,
        'text': <Some english sentence>,
        'stats': {
            'text': <some sentence>,
            'score': <some number>
        }
      }
    ]
  ]

  The seed program extracts only the conversational part and stores it in the database.
  The API fetched data from the database and gives it as `paginated JSON output` of the form:

  [
    log_index: <some unique number>,
    log_info: [
        {
            'user': <some dialogue>,
            'bot': <some dialogue>
        }
    ]
  ]

  * API URL -> `http://<ec2_domain_name>/api/v1/logs?page=<page number>`

  * Hosted on AWS using EC2, RDS, Nginx, and Load Balancer
 
  * Architecture
    ![alt text](https://github.com/rsj-rishabh/log-app-api/blob/main/log-app-design.png?raw=true)

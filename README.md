#  PROJECT SATAN 
## API ERRORS CHECKER BOT

1. [Bot Satan Regular Notification Process](#standard-way-of-configuration-to-get-notification)
2. [Bot Satan Standalone scripts to push notifications](#standalone-scripts-to-send-notifications)


#### INSTALLATION
* RUN  ``pip install -r requirements.txt``
* set a config file for required process look for ``sample_config.json`` for reference
* run ``python3 api_check_starter.py sample_config.json``

### Standard Way of configuration to get notification
#### Sample config file structure 
```
{
  "process": "process_1",
  "apis": {
    "Add Order": 8,
    "Onboard Subscriber": 4,
    "Get Subscriber Order": 2
  },
  "mysql_db_config": {
    "host": "127.0.0.1",
    "user": "root",
    "database":"remote_bkup",
    "password":"pass",
    "port":"3306"
  },
  "influx_db_config": {
    "host": "http://127.0.0.1:8086",
    "database": "matrics",
    "measurment": "nb_timeout_error"
  },
  "log_file_base_path": "/home/amandeep/bot_satan_logs/",
  "log_file_name": "nb_logs.log",
  "query_stage_1": "select distinct \"Add Order\" as 'a', \"\" as 'b', 1 as 'ok_count', 20 as 'not_ok_count', 21 as 'total_count' from dual;",
  "query_stage_2": "select * from add_order_api_error;"
  "lower_time": "epoch_time_if_testing_else_None",
  "current_time": "epoch_time_if_testing_else_None"
}
```
details about config file keys
* process - under this key give process name
* api - under this key give details of apis on what bot need to work with threshold values on same
* mysql_db_config - under this key give mysql connectivity credentials
* influx_db_config - under this key give influx connectivity credentials
* log_file_base_path - under this key give directory path of log file
* log_file_name - under this key give file name of log file
* query_stage_1 - under this key, give query string for execution of first phase to fetch apis list with their error count,
                output of this query pattern must should be 5 columns 
* lower_time, current_time - give epoch time to both of keys and run script for give time window

```
api name : str
any alias : str
success count : float
fail count : float
total count : float
```

* query_stage_2 - under this key, give query string for execution of second phase to fetch error list for particular api
                on output of this query pattern on third column there must should be error description of occurred error,
                and 4th column should be number of count of error occurred


### Work Flow
* Here on first stage we check first threshold condition for api as specified in config file if threshold is breached we go to second step to deeper analysis
* On second stage we categorize errors for from registered data, if threshold is breached for any category alert is send
* On second stage we also look for errors which didn't comes under any category and push them to mysql under unknown_errors category
* Unknown Errors are further processed by trained ML model categorised.


### Standalone Scripts to send notifications
Here we have some standalone small modules which are independent of above big configurations. which just pick data from
Influx or MySQL check alert conditions and push notifications. links of scripts are given below - 
* [Kafka Teams Notifications- logs from command](https://github.com/amandeep-aq/project-satan-python/blob/development/bot_satan_version_01/influx_to_teams_notification.py)
* [Kafka Teams Notifications - logs from logs file](https://github.com/amandeep-aq/project-satan-python/blob/development/bot_satan_version_01/influx_to_teams_notification_2.py)

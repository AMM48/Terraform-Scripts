resource "aws_sfn_state_machine" "step_function" {
  name     = "step_function"
  type     = "STANDARD"
  role_arn = var.step_function_role_arn
  definition = jsonencode({
    "Comment" : "State machine that invokes a Lambda function",
    "StartAt" : "Begin",
    "States" : {
      "Begin" : {
        "Type" : "Wait",
        "SecondsPath" : "$.waitSeconds",
        "Next" : "Invoke"
      },
      "Invoke" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::lambda:invoke",
        "Parameters" : {
          "FunctionName" : var.lambda_arn,
          "Payload" : {
            "Input.$" : "$"
          }
        },
        "Next" : "Finish"
      },
      "Finish" : {
        "Type" : "Pass",
        "End" : true
      }
    }
  })
  logging_configuration {
    include_execution_data = true
    level                  = "ALL"
    log_destination        = "${var.log_group_arn}:*"
  }
}


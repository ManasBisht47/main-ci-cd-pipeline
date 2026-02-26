variable "function_name"{
    type=string
}

variable "role"{
    type=string
}


variable "filename"{
    type=string
}


variable "handler"{
    type=string
}

variable "runtime"{
    type=string
}

variable "source_code_hash"{
    type = string
}
variable "layers"{
    type = list(string)
}

variable "environment_variables" {
  type = map(string)
  default = {}
}

variable "timeout" {

  type = number
  default = 30

}
variable "memory_size" {
  
  default = 512
}
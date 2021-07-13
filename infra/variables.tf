variable "subnet_ids" {
    type = list
    default = [
        "subnet-02857f9faf6535210",
        "subnet-0b3b4bdd44ed1a53c",
        "subnet-00872ba36e8d3256e",
        "subnet-0d411e81e37f37366"
    ]
  
}


variable "node_subnet_ids" {
    type = list
    default = [
        "subnet-02857f9faf6535210",
        "subnet-0b3b4bdd44ed1a53c"
        /* "subnet-00872ba36e8d3256e",
        "subnet-0d411e81e37f37366" */
    ]
  
}


variable "key" {
  type = string
  default = "eks-ssh-key"
}
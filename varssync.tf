variable "ipblock" {
    default = "10.10.0.0/16"
}
variable "tags_custom" {
    default = [{
        name = "ENV" 
        val= "Prod"
    },{
        name= "Project"
        val = "Test"
    }]
}
variable "project-name" {
    default = "Practise"
}

variable "env" {
    default = "Development"
}

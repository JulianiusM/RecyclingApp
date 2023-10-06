function sendMail() {
  const params = {
    name: document.getElementById("name").value,
    email: document.getElementById("email").value,
    message: document.getElementById("message").value,
  };

  if(Object.values(params).some(param => param === '')){
    alert("Fields must not be empty!");
    return;
  }



  const serviceID = "service_recycling";
  const templateID = "template_z5qj2i8";

    emailjs.send(serviceID, templateID, params)
    .then(res=>{
        document.getElementById("name").value = "";
        document.getElementById("email").value = "";
        document.getElementById("message").value = "";
        console.log(res);
        alert("Email was sent successfully!")

    })
    .catch(err=>alert(err));

}

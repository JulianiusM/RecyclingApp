function sendMail() {
   // fetch parameters from input-fields
  const params = {
    name: document.getElementById("name").value,
    email: document.getElementById("email").value,
    message: document.getElementById("message").value,
  };

  //Check if all fields were set in form
  if(Object.values(params).some(param => param === '')){
    alert("Fields must not be empty!");
    return;
  }

   //ToDO: Hide parameters
  const serviceID = "service_recycle";
  const templateID = "template_98qnybp";

    // send mail
    emailjs.send(serviceID, templateID, params)
    .then(res=>{
        document.getElementById("name").value = "";
        document.getElementById("email").value = "";
        document.getElementById("message").value = "";
        console.log(res);
        alert("Email was sent successfully, Thank you!")

    })
    .catch(err=>alert(err));

}

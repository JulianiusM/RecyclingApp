/**
 * Sends to contact-mail to corresponding mail-address
 */
function sendContactMail() {
    // fetch parameters from input-fields
    const params = {
        name: document.getElementById("name").value,
        email: document.getElementById("email").value,
        message: document.getElementById("message").value,
    };

    //Check if all fields were set in form
    if (Object.values(params).some(param => param === '')) {
        alert("Fields must not be empty!");
        return;
    }

    //ToDO: Hide parameters
    const serviceID = "service_recycle";
    const templateID = "template_98qnybp";

    // send mail
    emailjs.send(serviceID, templateID, params)
        .then(res => {
            // Reset fields in html
            document.getElementById("name").value = "";
            document.getElementById("email").value = "";
            document.getElementById("message").value = "";
            console.log(res);
            alert("Email was sent successfully, Thank you!")

        })
        .catch(err => alert(err));

}


/**
 * Sends feedback-mail to corresponding mail-address
 */
function sendFeedbackMail() {
    // fetch parameters from input-fields
    const params = {
        recommendNumber: document.getElementById("recommendNumber").innerText,
        likeNumber: document.getElementById("likeNumber").innerText,
        likeEspecially: document.getElementById("likeEspecially").value,
        couldBeImproved: document.getElementById("couldBeImproved").value,
    };


    //ToDO: Hide parameters
    const serviceID = "service_recycle";
    const templateID = "template_vzhahvr";

    alert(params.likeNumber)
    alert(params.recommendNumber)


    // send mail
    emailjs.send(serviceID, templateID, params)
        .then(res => {
            // Reset fields in html
            document.getElementById("recommendNumber").innerText = 1;
            document.getElementById("likeNumber").innerText = 1;
            document.getElementById("likeEspecially").value = "";
            document.getElementById("couldBeImproved").value = "";
            console.log(res);
            alert("Feedback was sent successfully, Thank you!")

        })
        .catch(err => alert(err));

}

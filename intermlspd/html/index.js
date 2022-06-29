$(function () {
    function display(bool) {
        if (bool) {
            $("#container").fadeIn();
        } else {
            $("#container").fadeOut();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://intermlspd/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post('http://intermlspd/exit', JSON.stringify({}));
        return
    })
    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://intermlspd/error", JSON.stringify({

                   }))
            return
        } else if (!inputValue) {
            $.post("http://intermlspd/error", JSON.stringify({
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('http://intermlspd/main', JSON.stringify({
            text: inputValue,
            
        }));
        return;
    })
})

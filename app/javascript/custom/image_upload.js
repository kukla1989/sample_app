//prevent from upload image more then 5 megabytes
document.addEventListener("turbo:load", function() {
    document.addEventListener("change", function (event) {
        let image_upload = document.querySelector('#micropost_image')
        const size_in_megabytes = image_upload.files[0].size/1024/1024
        if (size_in_megabytes > 5) {
            alert("Maximum size of file is 5MB. Please choose another file");
            image_upload.value = "";
        }
    });
});
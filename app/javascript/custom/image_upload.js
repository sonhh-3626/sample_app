document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (event) {
    const imageUpload = document.querySelector("#micropost_image");
    if (!imageUpload || !imageUpload.files.length) return;

    const sizeInMegabytes = imageUpload.files[0].size / 1024 / 1024;

    if (sizeInMegabytes > Settings.IMAGE_SIZE_LARGE_LIMIT_5) {
      alert(`Maximum file size is ${Settings.IMAGE_SIZE_LARGE_LIMIT_5}MB. Please choose a smaller file.`);
      imageUpload.value = "";
    }
  });
});

const IMAGE_SIZE_LARGE_MAXIMUM = 5;

document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (event) {
    const imageUpload = document.querySelector("#micropost_image");
    if (!imageUpload || !imageUpload.files.length) return;

    const sizeInMegabytes = imageUpload.files[0].size / 1024 / 1024;

    if (sizeInMegabytes > IMAGE_SIZE_LARGE_MAXIMUM) {
      alert(`${I18n.t("microposts.validations.image_size_too_large", { max_size: IMAGE_SIZE_LARGE_MAXIMUM })}`);
      imageUpload.value = "";
    }
  });
});

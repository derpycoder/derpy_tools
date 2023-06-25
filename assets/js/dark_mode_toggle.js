const DarkModeToggle = {
  mounted() {
    this.el.addEventListener("click", () => {
      if (localStorage.getItem("dark_mode") === "true") {
        localStorage.setItem("dark_mode", false);
        document.documentElement.classList.remove("dark");
      } else {
        localStorage.setItem("dark_mode", true);
        document.documentElement.classList.add("dark");
      }
    });
  },
};

export default DarkModeToggle;

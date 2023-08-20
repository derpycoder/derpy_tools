const KeyboardShortcuts = {
  mounted() {
    document.addEventListener("keyup", (e) => {
      // Ctrl + d
      if (e.key === "d" && e.ctrlKey) {
        e.preventDefault();
        if (localStorage.getItem("dark_mode") === "true") {
          localStorage.setItem("dark_mode", false);
          document.documentElement.classList.remove("dark");
        } else {
          localStorage.setItem("dark_mode", true);
          document.documentElement.classList.add("dark");
        }
      }
    });
  },
};

export default KeyboardShortcuts;

const TableOfContents = {
  mounted() {
    console.log(location.hash);
    if (location.hash) {
      const hash = location.hash.replace("#", "");
      const header = document.getElementById(hash);

      header &&
        header.scrollIntoView({
          behavior: "instant",
          block: "start",
          inline: "end",
        });

      const nav = document.getElementById(`${hash}-link`);

      if (nav) {
        nav.classList.remove(
          "hover:text-slate-900",
          "dark:text-slate-400",
          "dark:hover:text-slate-300"
        );
        nav.classList.add("text-sky-500", "dark:text-sky-400");
      }
    }
    window.addEventListener("hashchange", (event) => {
      if (event.oldURL.includes("#")) {
        const hash = event.oldURL.split("#").pop();

        if (hash) {
          const nav = document.getElementById(`${hash}-link`);

          if (nav) {
            nav.classList.remove("text-sky-500", "dark:text-sky-400");

            nav.classList.add(
              "hover:text-slate-900",
              "dark:text-slate-400",
              "dark:hover:text-slate-300"
            );
          }
        }
      }

      if (location.hash) {
        const nav = document.getElementById(
          `${location.hash.replace("#", "")}-link`
        );

        if (nav) {
          nav.classList.remove(
            "hover:text-slate-900",
            "dark:text-slate-400",
            "dark:hover:text-slate-300"
          );
          nav.classList.add("text-sky-500", "dark:text-sky-400");
        }
      }
    });
  },
};

export default TableOfContents;

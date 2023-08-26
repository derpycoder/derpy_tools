// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

import topbar from "../vendor/topbar";
import lozad from "../vendor/lozad";
import goodshare from "../vendor/goodshare";

import Clipboard from "./clipboard";
import DarkModeToggle from "./dark_mode_toggle";
import Ping from "./ping";
import PrimaryInput from "./primary_input";
import KeyboardShortcuts from "./keyboard_shortcuts";
import CommandPalette from "./command_palette";
import SpongeBobText from "./sponge_bob_text";
import ScrollIntoView from "./scroll_into_view";
import SourceInspector from "./source_inspector";
import LozadObserver from "./lozad_observer";
import AutoRedirect from "./auto_redirect";
import TableOfContents from "./table_of_contents";
import CopySnippet from "./copy_snippet";

window.goodshare = goodshare;

window.observer = lozad(); // lazy loads elements with default selector as '.lozad'
observer.observe();

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

const browserInfo = Intl.DateTimeFormat().resolvedOptions();

let liveSocket = new LiveSocket("/live", Socket, {
  params: {
    _csrf_token: csrfToken,
    locale: browserInfo.locale,
    timezone: browserInfo.timeZone,
  },
  metadata: {
    keydown: (e, el) => {
      return {
        key: e.key,
        metaKey: e.metaKey,
        altKey: e.altKey,
        ctrlKey: e.ctrlKey,
      };
    },
  },
  hooks: {
    Clipboard,
    DarkModeToggle,
    Ping,
    CommandPalette,
    PrimaryInput,
    SpongeBobText,
    ScrollIntoView,
    SourceInspector,
    LozadObserver,
    AutoRedirect,
    TableOfContents,
    KeyboardShortcuts,
    CopySnippet,
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(500));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// liveSocket.enableDebug()
// liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// liveSocket.disableLatencySim();
window.liveSocket = liveSocket;

window.addEventListener("phx:copy", (event) => {
  // let text = event.target.value; // Alternatively use an element or data tag!
  let text = event.target.innerHTML;
  navigator.clipboard.writeText(text).then(() => {
    console.log("All done!"); // Or a nice tooltip or something.
  });
});

window.addEventListener("phx:focus", (event) => {
  event.target.focus();
});

window.addEventListener("phx:open-command-palette", (event) => {
  const targetId = event.target.id;

  const bg = document.querySelector(`#${targetId}-bg`);
  const container = document.querySelector(`#${targetId}-container`);
  const content = document.querySelector(`#${targetId}-content`);

  event.target.style.display = "block";
  bg.style.display = "block";
  container.style.display = "block";
  document.body.classList.add("overflow-hidden");
  content.focus();
});

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener("DOMContentLoaded", () => {
      this.initHeartbeat();
    });
  }

  initHeartbeat() {
    this.lastActive = new Date().valueOf();
    if (!this.heartBeatActivated) {
      ["mousemove", "scroll", "click", "keydown"].forEach((activity) => {
        document.addEventListener(
          activity,
          (ev) => {
            this.lastActive = ev.timeStamp + performance.timing.navigationStart;
          },
          false
        );
      });
      this.heartBeatActivated = true;
    }
    this.pollForSessionTimeout();
  }

  pollForSessionTimeout() {
    const pollFrequency = 5;
    const userSessionMeta = document.querySelector('meta[name="user-session"]');

    if (!userSessionMeta.content) {
      setTimeout(this.pollForSessionTimeout.bind(this), pollFrequency * 1000);
      return;
    }

    if (Date.now() - this.lastActive < pollFrequency * 1000) {
      setTimeout(this.pollForSessionTimeout.bind(this), pollFrequency * 1000);
      return;
    }

    let request = new XMLHttpRequest();
    request.onload = function (event) {
      var status = event.target.status;
      var response = event.target.response;

      // if the remaining valid time for the current user session is less than or equals to 0 seconds.
      if (status === 200 && response <= 0) {
        window.location.href = "/session_timeout";
      }
    };
    request.open("GET", "/check_session_timeout", true);
    request.responseType = "json";
    request.send();
    setTimeout(this.pollForSessionTimeout.bind(this), pollFrequency * 1000);
  }
}

import { apiInitializer } from "discourse/lib/api";

const isLogoutKey = 'is_logout';
const testEnv = '.test.osinfra.cn';

function getCookie() {
  const name = '_U_T_';
  const matchField = name + '=';
  const ca = document.cookie.split(';');
  for (let i = 0; i < ca.length; i++) {
    const c = ca[i].trim();
    if (c.indexOf(matchField) === 0) {
      return c.substring(matchField.length, c.length);
    }
  }
  return '';
}

// 同步官网登录
function syncLoginStatus() {
  const userToken = getCookie();
  if (userToken) {
    const loginDom = document.querySelector('.header-buttons .auth-buttons .login-button');
    // 找到登录dom元素表示没有登录，手动触发一次点击事件
    if (loginDom) {
      loginDom.click();
    }
  }
}

// 论坛登出，调取官网接口，退出官网
async function logoutForum() {
  const curUrl = new URL(window.location.href);
  if (curUrl.href.includes(testEnv)) {
    await fetch(
      "/gauss-logout-test",
      {
        method: "GET",
        headers: { "Content-Type": "application/json" }
      }).then((res) => {
        return res.json();
      });
  } else {
    await fetch(
      "/gauss-logout",
      {
        method: "GET",
        headers: { "Content-Type": "application/json" }
      }).then((res) => {
        return res.json();
      });
  }
}

export default apiInitializer("1.34.0", (api) => {
  api.renderInOutlet("home-logo-contents", <template>
    <a class="forum-logo logo_pc" href="/">
    </a>
    <a class="forum-logo logo_mb" href="/">
    </a>
    <span class="divid"></span>
    <a
      class="website-logo lang-zh"
      href="https://opengauss.org/zh/"
      target="_blank"
    >
    </a>
    <a
      class="website-logo lang-en"
      href="https://opengauss.org/en/"
      target="_blank"
    >
    </a>
  </template>);

  let isUserFirstListen = false;
  let isAvatarFirstListen = false;
  let isQuitFirstListen = false;

  api.onAppEvent("page:changed", async () => {
    const isLogout = sessionStorage.getItem(isLogoutKey);

    if (isLogout === null) {
      // 同步官网登录
      syncLoginStatus();
    }

    if(isLogout) {
      sessionStorage.removeItem(isLogoutKey);
      await logoutForum();
    } else{
        // 论坛登出，官网同步登出
        const userBtn = document.querySelector('.header-buttons .current-user .avatar');
        if (!isUserFirstListen) {
          isUserFirstListen = true;
          userBtn.addEventListener("click", () => {
            if (!isAvatarFirstListen) {
              isAvatarFirstListen = true;
              requestAnimationFrame(() => {
                const avatarIcon = document.querySelector('.user-menu-dropdown-wrapper .bottom-tabs .user-menu-tab');
                avatarIcon.addEventListener("click", () => {
                  if (!isQuitFirstListen) {
                    isQuitFirstListen = true;
                    const logoutBtn = document.querySelector('.user-menu .quick-access-panel .logout button');
                    if (logoutBtn) {
                      logoutBtn.addEventListener("click", () => {
                        sessionStorage.setItem(isLogoutKey, true);
                      });
                    }
                  }
                });
              });
            }
          });
        }
    }
  });
});

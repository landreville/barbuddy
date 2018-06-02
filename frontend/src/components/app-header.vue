<template>
    <header>
      <div class="header-title">
        <h1 class="title">
          <router-link :to="{ name: 'recipes' }">{{ title }}</router-link>
        </h1>
      </div>
      <div class="nav-container">
        <nav>
          <div class="nav-item"
               v-for="linkItem in breadcrumbs()"
               :linkItem="linkItem"
               :key="linkItem[0]">
            <router-link class="navlink"
                         :to="linkItem[1]">{{ linkItem[0] }}</router-link>

          </div>
        </nav>

        <div class="auth-status">
          <span class="auth-status__links" v-if="!loggedIn">
            <a class="auth-status__link auth-status__login"
               @click.prevent="login()">Login</a>
            /
            <a class="auth-status__link auth-status__signup"
               @click.prevent="login()">Sign-Up</a>
          </span>
          <span class="auth-status__links" v-if="loggedIn">
            <a class="auth-status__link auth-status__profile">{{ username }}</a>
          </span>
        </div>

      </div>
    </header>
</template>

<script>
import firebase from 'firebase';
import firebaseui from 'firebaseui';
import { firebaseConfig } from '../lib/config';
import { store } from '../lib/store';

export default {
  name: 'app-header',
  props: ['title'],
  created() {
    firebase.initializeApp(firebaseConfig);
    firebase.auth().onAuthStateChanged(this.changeAuthState);
  },
  mounted() {
    let uiConfig = {
      signInSuccessUrl: '/success',
      signInOptions: [
        firebase.auth.GoogleAuthProvider.PROVIDER_ID,
        firebase.auth.EmailAuthProvider.PROVIDER_ID
      ]
    };
    let ui = new firebaseui.auth.AuthUI(firebase.auth());
    ui.start('#firebaseui-auth-container', uiConfig);
  },
  data() {
    return {
      username: '',
      loggedIn: false
    };
  },
  methods: {
    breadcrumbs() {
      let links = [];
      let bc = this.$route.meta.breadcrumbs;
      if (!bc) {
        return [];
      }

      for (let i = 0; i < bc.length; i++) {
        let linkItem = bc[i];
        if ({}.toString.call(linkItem) === '[object Function]') {
          linkItem = linkItem(this.$route);
        }
        links.push(linkItem);
      }
      return links;
    },
    changeAuthState(user) {
      if (user) {
        // // User is signed in.
        // let displayName = user.displayName;
        // let email = user.email;
        // let emailVerified = user.emailVerified;
        // let photoURL = user.photoURL;
        // let uid = user.uid;
        // let phoneNumber = user.phoneNumber;
        // let providerData = user.providerData;
        user.getIdToken().then((accessToken) => {
          store.setAccessToken(accessToken);
          this.username = user.displayName;
          this.loggedIn = true;
        });
      } else {
        // User is signed out.
        this.loggedIn = false;
        this.username = '';
      }
    },
    login() {
      let provider = new firebase.auth.GoogleAuthProvider();
      firebase.auth().signInWithPopup(provider).then().catch((error) => {
        // let errorCode = error.code;
        let errorMessage = error.message;
        // let email = error.email;
        // let credential = error.credential;
        console.log('Error signing in.', errorMessage);
      });
    }
  }
};
</script>

<style scoped>
header{
  width: 100%;
}

.header-title{
  margin: 0 auto;
  text-align: center;
  color: rgb(68, 68, 68);
}

.title{
  font-family: "Josefin Sans", sans-serif;
  font-weight: bold;
  font-size: 4rem;
  line-height: 4rem;

  margin: 0;
  padding: 1rem 0
}

.title a{
  color: inherit;
  text-decoration: none;
  outline: none;
}


.nav-container{
  border-top: 3px double rgb(200, 200, 200);
  border-bottom: 3px double rgb(200, 200, 200);

  display: flex;
  justify-content: space-between;
}

nav{
  margin-left: 1rem;
  display: flex;
}

.nav-item{
  line-height: 1em;
  margin: 0.5rem 0;
}

.nav-item::after{
  content: "›";
  margin: 0.5rem 1rem;
}

.nav-item:last-child::after{
  content: "";
}

.navlink{
  color: rgb(68, 68, 68);
}
.navlink.active{
  /*text-decoration: underline;*/
}

.auth-status{
  margin-right: 1rem;
}
</style>

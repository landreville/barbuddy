<template>
    <div class="login">
      <div class="message">
        {{ message }}
      </div>
      <form class="login-form">
        <div class="field">
          <input name="email" type="text" v-model="email" placeholder="Email"/>
        </div>
        <div class="field">
          <input name="password" type="password" v-model="password" placeholder="Password"/>
        </div>
        <div class="buttons">
          <button type="submit" @click="login">Login</button>
        </div>
      </form>
    </div>
</template>

<script>
import { ApiClient } from '../lib/apiclient';

export default {
  name: 'login',
  data() {
    return {
      email: null,
      password: null,
      message: ''
    };
  },
  methods: {
    login(event) {
      event.preventDefault();
      ApiClient.login(this.email, this.password).then((success) => {
        if (success) {
          console.log('Logged in');
          this.$router.push({ name: 'recipes' });
        }
      });
      this.email = null;
      this.password = null;

    }
  }
};
</script>

<style scoped>
  .login{
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .field{
    margin-bottom: 1rem;
  }
</style>

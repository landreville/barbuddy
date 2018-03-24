<template>
  <div class="header">
    <div class="header__title">
        <a class="header__link" href="/">
            {{ site_title }}
        </a>
    </div>
  </div>
</template>

<script>
  export default {
    name: "header",
    data() {
      return {
        site_title: "Bar Chef"
      }
    }
  }
</script>

<style scoped>
  .header{
    text-align: center;
    margin-bottom: 5rem;
  }

  .header__title {
      font-family: "Josefin Sans", sans-serif;
      font-weight: bold;
      font-size: 5rem;
      line-height: 5rem;
  }

  a.header__link{
    color: rgb(68, 68, 68);
  }

  a.header__link:hover{
      /* Link underline that clears descenders */
      color: rgb(68, 68, 68);
      /* Shadow is same colour as background. */
      text-shadow: 3px 0 #ffffff, 2px 0 #ffffff, 1px 0 #ffffff, -1px 0 #ffffff, -2px 0 #ffffff, -3px 0 #ffffff;
      text-decoration: none;
      background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 50%);
      background-repeat: repeat-x;
      background-size: 1px 9px;
      background-position: 0 3.9rem;
  }
</style>

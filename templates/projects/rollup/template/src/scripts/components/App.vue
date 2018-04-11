<template>
  <div>
    <div v-for='a in list'> {{a}} </div>
  </div>
</template>

<script>
  export default {
    data () {
      return {
        list: ['apple', "banana", 'sherry']
      }
    }
  }
</script>

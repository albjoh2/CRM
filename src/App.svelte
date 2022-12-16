<script>
  import OrderForm from './lib/OrderForm.svelte';
  import NavBar from './lib/NavBar.svelte';
  import OrderList from './lib/OrderList.svelte';
  import Clients from './lib/Clients.svelte';
  import Articles from './lib/Articles.svelte';
  import Prices from './lib/Prices.svelte';
  import Stats from './lib/Stats.svelte';

  console.log(window.location.pathname);

</script>

<main>
  <NavBar/>
  


    {#if window.location.pathname === '/orderview'}

      <OrderForm/>
    {:else if window.location.pathname === '/orderlist'}

      <OrderList/>
    {:else if window.location.pathname === '/clients'}

      <Clients/>
    {:else if window.location.pathname === '/articles'}

      <Articles/>
    {:else if window.location.pathname === '/prices'}

      <Prices/>
    {:else if window.location.pathname === '/stats'}

      <Stats/>
    {:else}
      <h1>Overview</h1>
      <div></div>
      <OrderList/>
      <div></div>
      <Clients/>
      <div></div>
      <Articles/>
      <div></div>
      <Prices/>
      <div></div>
      <Stats/>
    {/if}




</main>

<style>

    div{
      width: 100%;
      height: 1px;
      background-color: #bbb;
    }
</style>

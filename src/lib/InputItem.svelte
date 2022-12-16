
<script>
    export let listItemText;
    export let highlighted = false;

</script>


<li class="autocomplete-items" class:autocomplete-active={highlighted} on:keydown on:click>{@html listItemText}</li>

<style>
    li.autocomplete-items {
        position: relative;
        list-style: none;
        border: 1px solid #eeeeee;
        z-index: 99;
        top: 100%;
        left: 0;
        right: 0;
    }
    li {
        padding: 10px;
        cursor: pointer;
        background-color: #fff;
        border-bottom: 1px solid #d4d4d4;
    }
    li:hover {
        background-color: #e9e9e9;
    }
    .autocomplete-active {
        background-color: DodgerBlue !important;
        color: #ffffff;
    }

</style>
<script>
import Input from "./Input.svelte";

</script>

<div>
    <form>
        <div>
            <Input on:input on:click/>
            <!-- <input class="art" maxlength="27" type="text" placeholder="Article" on:input>     -->
            <input class="amo" maxlength="5" max="99999" type="number" placeholder="Amount" min="1" on:input>   
        </div>
    </form>
    <button class="remove" on:click>x</button>
</div>

<style>

    button{
        color: red;
        font-size: 20px;
        font-weight: 900;
        display: inline-block;
    }        
    .amo{
        width: 72px;
    }
    div{
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
        margin: 0px;
        width: 350px;
    }

</style>
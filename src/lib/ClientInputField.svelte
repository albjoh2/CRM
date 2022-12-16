<script>
    import InputItem from "./InputItem.svelte";
    let clients = [];

    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("client")){
            let client = JSON.parse(localStorage.getItem(key));
            clients.push(client);
        }
    }

    let filteredClients = []
    export let inputValueClient = ""

    function filterClients(){
        let storageArray = [];
        if(inputValueClient){
            clients.forEach(client => {
                if(client.name.toLowerCase().includes(inputValueClient.toLowerCase()) || client.id.toString().includes(inputValueClient)){
                    storageArray = [...storageArray, makeMatchBold(client.id.toString() + " " + client.name)];
                }
            })
        }else{
            filteredClients = []
        }
        filteredClients = storageArray;
    }

    function makeMatchBold(str){
        let index = str.toLowerCase().indexOf(inputValueClient.toLowerCase())
        let firstPart = str.slice(0, index)
        let secondPart = str.slice(index + inputValueClient.length)
        return firstPart + "<strong>" + inputValueClient + "</strong>" + secondPart
    }

    let highlightedIndex = -1;

    const navigateList = (e) => {
        if(e.key === "ArrowDown"){
            e.preventDefault();
            if(highlightedIndex < filteredClients.length - 1){
                highlightedIndex++;
            }
        }else if(e.key === "ArrowUp"){
            e.preventDefault();
            if(highlightedIndex > 0){
                highlightedIndex--;
            }
        }else if(e.key === "Enter"){
            e.preventDefault();
            if(highlightedIndex > -1){
                inputValueClient = filteredClients[highlightedIndex].replace("<strong>", "").replace("</strong>", "");
                filteredClients = [];
                highlightedIndex = -1;
            }
        }
    }

    let clientDoNotExist = true;

    $: inputValueClient && checkIfClientExist();

    function checkIfClientExist(event){
        if(event){
            inputValueClient = event.currentTarget.innerText
        }
        clientDoNotExist = true;
        clients.forEach(client => {
            if(client.id.toString() + " " + client.name.toLowerCase() === inputValueClient.toLowerCase()){
                clientDoNotExist = false;
            }
        })
    }

</script>

<svelte:window on:keydown={navigateList} />

<form autocomplete="off">
    <div class="autocomplete">
      <input class:wrong={clientDoNotExist} on:blur={()=>{checkIfClientExist()}} id="myInput" class="art" type="text" bind:value={inputValueClient} name="client" placeholder="Client" on:input on:input={filterClients}>
      <ul class="autocomplete-items-cont">
          {#each filteredClients as client, i}
              <InputItem on:click highlighted={i === highlightedIndex} listItemText={client} on:click={(event)=>{
                checkIfClientExist(event)
                filteredClients = []
                }}/>
          {/each}
      </ul>
    </div>
</form>

  <style>
    ul{
        margin: 0;
        width: inherit;
        padding: 0 10px;
    }
    .wrong{
        border: 1px solid red;
    }
    .autocomplete {
        width: 230px;
        position: relative;
        display: inline-block;
    }
    .autocomplete-items-cont{
        position: absolute;
        z-index: 99;
        top: 100%;
        left: 0;
        right: 0;
    }
    input {
        border: 1px solid transparent;
        background-color: #f1f1f1;
        padding: 10px;
        font-size: 16px;
        width: 100%;
    }
    input[type=text] {
        background-color: #f1f1f1;
        width: 100%;
    }


  </style>
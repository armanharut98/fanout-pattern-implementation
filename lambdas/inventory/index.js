exports.handler = async (event) => {
    console.log("Inventory Lambda triggered!")
    console.log(`Message: ${JSON.stringify(event)}`)
    return event
}
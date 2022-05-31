export async function attempt(run, number){
    if(number === 0) return;
    try {
        await run();
    } catch {
        console.log("there was an error, re-attempting to run macro...")
        await attempt(run, number - 1);
    }
}

import * as sdk from "https://deno.land/x/appwrite@10.0.1/mod.ts";
if (import.meta.main) {
    print ("Hello world");    
}

export default async function(req, res) {
    // Initialize the Appwrite client
    const client = new Client();
  
    // Use environment variables to configure the client
    client
      .setEndpoint(Deno.env.get('APPWRITE_ENDPOINT') || '')
      .setProject(Deno.env.get('APPWRITE_FUNCTION_PROJECT_ID') || '')
      .setKey(Deno.env.get('APPWRITE_API_KEY') || '');
  
    // Create a new instance of a service
    // For example, let's use the Database service
    const database = new sdk.Appwrite.Database(client);
  
    try {
      // Example: Fetch documents from a collection
      // Replace 'databaseId' and 'collectionId' with your actual values
      const databaseId = '6805410d0028b5905c9d';
      const collectionId = '6805411800123f123ea9';
      
      const response = await database.listDocuments(
        databaseId,
        collectionId
      );
  
      // Return the response as JSON
      return res.json(response);
    } catch (error) {
      // Handle any errors
      console.error('Error:', error);
      return res.json(
        {
          success: false,
          message: error.message,
        }, 
        500
      );
    }
  }
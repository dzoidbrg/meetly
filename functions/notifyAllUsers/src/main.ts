import * as sdk from "https://deno.land/x/appwrite/mod.ts";

const DATABASE_ID = '6805410d0028b5905c9d';
const EVENTS_COLLECTION_ID = '6805411800123f123ea9';
const NOTIFICATIONS_COLLECTION_ID = '68069e1700185f62ec30';


interface NotifyAllUsersRequest {
  participants: [string],
  eventID: string
}
// This Appwrite function will be executed every time your function is triggered
export default async ({ req, res, log }: any) => {
  log(JSON.stringify(req.bodyJSON));                  // Raw request body, contains request data
  const parsedRequest: NotifyAllUsersRequest = req.bodyJSON // Object from parsed JSON request body, otherwise string
  const client = new sdk.Client()
    .setEndpoint(Deno.env.get("APPWRITE_FUNCTION_API_ENDPOINT") ?? '')
    .setProject(Deno.env.get("APPWRITE_FUNCTION_PROJECT_ID") ?? '')
    .setKey(req.headers['x-appwrite-key'] ?? '');
    
  const databases = new sdk.Databases(client);
  const messaging = new sdk.Messaging(client);

  for (const participant of req.bodyJSON.participants) {
    await databases.createDocument(DATABASE_ID, NOTIFICATIONS_COLLECTION_ID, participant, {
      userID: participant,
      type: "EVENT_INVITATION_HAS_BEEN_ADDED",
      invitedEventId: req.bodyJSON.eventID
    });
    await messaging.createPush(sdk.ID.unique(), "You have been invited to an event!", "Check Meetly for further details",[],[participant])
  }
  return res.text("All participants have been invited");
}

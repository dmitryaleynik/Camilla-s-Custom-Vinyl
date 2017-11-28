/**
 * Created by HP on 28.11.2017.
 */
public class Utils {
	public Map<sObject, Id> getParentIds (List<sObject> objects, String parentIdName)
	{
		Map<sObject, Id>  parentIds = new Map<sObject, Id>();
		for(sObject obj : objects)
		{
			Id currParentId = (Id)obj.get(parentIdName);
			parentIds.put(obj,currParentId);
		}
		return parentIds;
	}

}
module FriedChicken
  class SalesForce

    include GlobalUtilities::SalesForce::Base
    include GlobalUtilities::SalesForce::Concerns::DB

    def initialize(api_object)
      @api_object         = api_object
      @storage_object     = convert_api_object_to_local_storage(api_object)
      @problems           = []
      map_attributes(api_object)
      self
    end

    def box_client
      FriedChicken::BoxClient.instance
    end


    private

  end
end

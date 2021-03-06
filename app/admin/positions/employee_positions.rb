ActiveAdmin.register Position::Employee, as: 'EmployeePosition' do
  menu parent: 'Positions', priority: 2

  permit_params :name, :business_id, :role, manager_position_ids: []

  config.sort_order = 'name_asc'

  controller do
    def create
      params[:position_employee][:business_id] = current_business.id
      super
    end
  end

  index do
    column :name
    column(:manager_positions) { |resource| resource.manager_positions.pluck(:name).join(', ') }
    actions
  end

  filter :name
  filter :manager_positions,
         as: :select,
         collection: proc { current_business.manager_positions }

  show do
    attributes_table do
      row :name
      row(:manager_positions) { |resource| resource.manager_positions.pluck(:name).join(', ') }
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      collected_data = current_business.manager_positions.map do |position|
        [
          position.name,
          position.id,
          {
            checked: f.object.manager_positions.include?(position)
          }
        ]
      end
      f.input :manager_positions, as: :check_boxes, collection: collected_data
    end
    f.actions
  end
end

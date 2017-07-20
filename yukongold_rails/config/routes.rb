Rails.application.routes.draw do

   
  get '/home' => 'sittings#select_sitting'
   # post '/home' => 'sittings#select_sitting'

  mount Upmin::Engine => '/admin'

  devise_for :users, :controllers => { registrations: 'users/registrations' }
  
  # devise_scope :user do
  # 	root :to => "devise/sessions#new"
  # end

  devise_scope :user do
    authenticated :user do
      root 'sittings#select_sitting', as: :authenticated_root
      # match '/sessions/user', to: 'devise/sessions#create', via: :post
    end

    unauthenticated do
      # root 'devise/sessions#new', as: :unauthenticated_root
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

 # users
  get "users/new" => "users#new", as: :users_new_user
  post "users/create_user" => "users#create", as: :users_create_user 
  get "users/:id/edit" => "users#edit", as: :users_edit_user 
  put "users/:id" => "users#update", as: :users_update_user 

 # calendars/google authenication
  resources :calendars
  get "/auth/:provider/callback" => 'calendars#create'
  post "/calendars" => 'calendars#new'

  #sittings
  
  get '/sittings/refresh' => 'sittings#refresh'
  post '/sittings/refresh' => 'sittings#refresh'
  # get '/sittings/create_calendar'  => 'sittings#create_calendar' 
  get '/sittings/update_calendar'  => 'sittings#update_calendar'
  get '/sittings/select_sitting'  => 'sittings#select_sitting'
  post '/sittings/select_sitting'  => 'sittings#select_sitting'
  post '/sittings/update_sitting' => 'sittings#update_sitting'
  get '/sittings/update_sitting' => 'sittings#update_sitting'
  post '/sittings/update' => 'sittings#update'
  post '/sittings/view_past_sittings' => 'sittings#view_past_sittings'
  get '/sittings/view_past_sittings' => 'sittings#view_past_sittings'
  

  #students
  delete '/students/:students_sittings_id/cancel_attendance' => 'students#cancel_attendance'
  post '/students/attendance/' => 'students#attendance'
  get '/students/attendance', to:'students#attendance'
  get '/students/list_all' => 'students#list_all'
  post '/students/list_all' => 'students#list_all'
  post '/students/update_list_all_student' => 'students#update_list_all_student'
  post '/students/update_students_sitting_autocomplete' => 'students#update_students_sitting_autocomplete'
  post '/students/update_student_status' => 'students#update_student_status'
  get '/students/autocomplete', to: 'students#autocomplete', as: 'autocomplete_student'
  # post '/students/js_add_student_to_sitting', to: 'students#js_add_student_to_sitting'
  get 'students/home' => 'students#home'
  get '/students/schedule_meetings' => 'students#schedule_meetings'
  post '/students/schedule_meetings' => 'students#schedule_meetings'
  get '/students/:group_id/new_dropdown' =>'students#new_dropdown'
  post '/students/new_dropdown' =>'students#new_dropdown'
  get '/students/manage_students' => 'students#manage_students'
  post '/students/manage_students' => 'students#manage_students'
  get '/students/manage_inactive_students' => 'students#manage_inactive_students'
  post '/students/manage_inactive_students' => 'students#manage_inactive_students'
  post '/students/new' => 'students#new'
  get  'students/:id/history' => 'students#history'
  post '/students/:id/history' => 'students#history'
  post '/students/:id/edit' => 'students#edit'
  post '/students/:id/update' => 'students#update'
  patch '/students/:id/update' => 'students#update'
  get '/students/update' => 'students#update'
  post '/students/update' => 'students#update'

  #special_status
  get '/students/:student_id/new_special_status' => 'students#new_special_status'
  post '/students/update_special_status' => 'students#update_special_status'

  #location
  post '/students/update_location_status' => 'students#update_location_status'
  
  #meetings
  post '/meetings/:meeting_id/delete_other_meeting' => 'meetings#delete_other_meeting'
  delete '/meetings/:meeting_id/delete_other_meeting' => 'meetings#delete_other_meeting'
  post '/meetings/:meeting_id/edit_other_meeting' => 'meetings#edit_other_meeting'
  get '/meetings/:meeting_id/edit_other_meeting' => 'meetings#edit_other_meeting'
  get '/meetings/:student_id/new' => 'meetings#new'
  post '/meetings/update' => 'meetings#update'
  delete '/meetings/:meeting_id/destroy' => 'meetings#destroy'
  post '/meetings/new_other_meeting' => 'meetings#new_other_meeting'
  get '/meetings/new_other_meeting' => 'meetings#new_other_meeting'
  get '/meetings/autocomplete', to: 'meetings#autocomplete', as: 'autocomplete_meeting'
  get '/meetings/show_other' => 'meetings#show_other'
  post '/meetings/show_other' => 'meetings#show_other'

  #groups
  delete '/groups/:students_groups_id/delete_students_groups' => 'groups#delete_students_groups'
  delete '/groups/:id/delete_group' => 'groups#delete_group'
  get '/groups/:id/all_students_in_group' => 'groups#all_students_in_group'
  post '/groups/manage_groups' => 'groups#manage_groups'
  get '/groups/manage_groups' => 'groups#manage_groups'
  post '/groups/update_students_in_group' => 'groups#update_students_in_group'
  post '/groups/new' => 'groups#new'
  post '/groups/:id/edit' => 'groups#edit'
  get '/groups/:id/update' => 'groups#update'
  post '/groups/:id/update' => 'groups#update'
  patch '/groups/:id/update' => 'groups#update'
  get '/groups/update' => 'groups#update'
  post '/groups/update' => 'groups#update'

  #notes
  post '/notes/new' => 'notes#new'
  get '/notes/update' => 'notes#update'
  post '/notes/update' => 'notes#update'
  post '/notes/:id/edit' => 'notes#edit'
  delete '/notes/:id/destroy' => 'notes#destroy'

  #reports
  get 'reports/generate_reports' => 'reports#generate_reports'
  post 'reports/generate_reports' => 'reports#generate_reports'
  post 'reports/new' => 'reports#new'
  get 'reports/attendance_report' => 'reports#attendance_report'
  post 'reports/attendance_report' => 'reports#attendance_report'
  get 'reports/meeting_report' => 'reports#meeting_report'
  post 'reports/meeting_report' => 'reports#meeting_report'
  get 'reports/student_report' => 'reports#student_report'
  post 'reports/student_report' => 'reports#student_report'


  # resources :sessions
  # resources :users
  resources :reports
  resources :students
  resources :meetings
  resources :monastics
  resources :sittings
  resources :students_sittings
  resources :attendance_status_types
  resources :groups
  resources :notes
  
  get '/visitors/instructions' => 'visitors#instructions'

end
  


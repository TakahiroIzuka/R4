import { createClient } from '@/lib/supabase/server'
import ServiceManager from '@/components/management/ServiceManager'

export default async function ServicesPage() {
  const supabase = await createClient()

  // Fetch services data
  const { data: services } = await supabase
    .from('services')
    .select('*')
    .order('id', { ascending: false })

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-6">マスタ管理 - サービス</h1>
      <ServiceManager services={services || []} />
    </div>
  )
}

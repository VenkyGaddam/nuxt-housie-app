export default defineNuxtRouteMiddleware((to, from) => {
  const appConfig = useAppConfig();
  const primaryColor = useCookie("nuxt-ui-primary").value;
  const grayColor = useCookie("nuxt-ui-gray").value;

  if (primaryColor) appConfig.ui.primary = primaryColor;
  if (grayColor) appConfig.ui.gray = grayColor;
  return;
});
